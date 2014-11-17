require 'solr_ead'
require 'typhoeus'

class CustomDocument < SolrEad::Document
  use_terminology SolrEad::Document

  def component_path
    'c01|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12'
  end

  extend_terminology do |t|
    t.author(:path => 'filedesc/titlestmt/author')
    t.physloc(:path => 'archdesc/did/physloc')
    t.prefercite(:path => 'archdesc/prefercite/p')

    # This conflicts with the old definition
    t.creator(:path => 'archdesc/did/origination/persname')

    t.c01
  end
end

module ExploreukEadHelper
  def containers_for(item)
    item.xpath('did/container').collect do |container|
      {
        'type' => type_for(container),
        'label' => container.content,
      }
    end
  end

  def type_for(container)
    # https://github.com/cokernel/ibrik/blob/14df84c6e90af8aa1e8be2a502f0eea83a9d2cfc/lib/kdl/ead_component.rb#L24
    bad_types = ['folder/item', 'othertype']
    candidates = [container['type'], container['label'], 'folder']
    candidates.compact.collect {|candidate|
      candidate.downcase.strip
    }.reject {|candidate|
      bad_types.include? candidate
    }.first
  end

  def subitems_for(item, item_id)
    c = "c|c01|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12"
    result = []
    if item.xpath(c).count > 0
      item.xpath(c).each_with_index do |subitem, index|
        h = {
          'title' => subitem.xpath('did/unittitle').first.content,
          'level' => subitem.xpath('@level').first.content,
          'id' => "#{item_id}_#{index}",
        }
        if subitem.xpath('did/unitdate').first
          h['unitdate'] = subitem.xpath('did/unitdate').first.content
        end
        h['containers'] = containers_for(subitem)
        if h['containers'].count > 0
          h['container_list'] = h['containers'].collect {|c|
            "#{c['type']} #{c['label']}"
          }.join(', ').capitalize
        end
        if subitem.xpath('scopecontent').first
          if subitem.xpath('scopecontent').first.xpath('p')
            h['scopecontent'] = subitem.xpath('scopecontent').first.xpath('p')
          end
        end
        if subitem.xpath('did/dao').first
          h['dao'] = subitem.xpath('did/dao').first['entityref']
        end
        h['subitems'] = subitems_for(subitem, h['id'])
        result << h
      end
    end
    result 
  end

  # This will eventually happen in indexing
  def eadize document = nil
    if document['finding_aid_url_s']
      doc = document.dup
      xml = Typhoeus.get(doc['finding_aid_url_s']).body
      ead = CustomDocument.from_xml(xml)
      doc['ead_header'] = {}
      doc['ead_header'] = {
        'author' => ead.author,
        'title' => ead.title,
        'date' => ead.unitdate,
        'arrangement' => ead.arrangement,

        'location_note' => ead.physloc,
        'accessrestrict' => ead.accessrestrict,
        'prefercite' => ead.prefercite,
        'extent' => ead.extent,

        'creator' => ead.creator,
        'abstract' => ead.abstract,
        'bioghist' => ead.bioghist,
        'scopecontent' => ead.scopecontent,

        'subjects' => ead.subject,
        'userestrict' => ead.userestrict,

        # There are two sources for this
        'related_material' => ead.relatedmaterial,
      }
      doc['ead_header'].each do |key, value|
        if value.count < 1
          doc['ead_header'].delete(key)
        end
      end
      doc['ead_inventory'] ||= []
      ead.c01.nodeset.each_with_index do |c01, index|
        h = {
          'title' => c01.xpath('did/unittitle').first.content,
          'level' => c01.xpath('@level').first.content,
          'id' => "ead_#{index}"
        }
        h['containers'] = containers_for(c01)
        if h['containers'].count > 0
          h['container_list'] = h['containers'].collect {|c|
            "#{c['type']} #{c['label']}"
          }.join(', ').capitalize
        end
        if c01.xpath('scopecontent').first
          if c01.xpath('scopecontent').first.xpath('p')
            h['scopecontent'] = c01.xpath('scopecontent').first.xpath('p')
          end
        end
        if c01.xpath('did/dao').first
          h['dao'] = c01.xpath('did/dao').first['entityref']
        end
        h['subitems'] = subitems_for(c01, h['id'])
        doc['ead_inventory'] << h
      end
      doc
    else
      document
    end
  end

  def ead_header_fields document = nil
    if document['ead_header']
      document['ead_header'].keys
    end
  end

  def ead_toc_items document = nil
    document['ead_inventory']
  end

  def should_render_ead_header_field?(document, field)
    document['ead_header'][field]
  end

  def ead_header_label document, field
    I18n.t("exploreuk.ead.header.#{field}")
  end

  def ead_header_value document, field
    if document['ead_header'][field].count > 1
      document['ead_header'][field].collect {|item| "<p>#{item}</p>"}.join('').html_safe
    else
      document['ead_header'][field].first
    end
  end

  def ead_header_anchor document, field
    field.parameterize
  end

  def should_render_ead? document
    document.has_key?(blacklight_config.show.ead_field) and
    document.has_key?('unpaged_display') # hardcoded for now
  end
end
