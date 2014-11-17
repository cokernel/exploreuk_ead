require "spec_helper"

describe "ExploreUK EAD", :type => :feature do
  let (:blacklight_config) do
    Blacklight::Configuration.new do |config|
    end
  end

  before do
    load_sample_documents
    CatalogController.blacklight_config = blacklight_config
  end

  let (:ead_path) {"/catalog/sample_ead"}
  let (:ead_item_path) {"/catalog/sample_ead_1_1"}
  let (:ead_loc_path) {"/catalog/sample_ead2"}
  let (:ead_rel_path) {"/catalog/sample_ead3"}
  let (:ead_subseries_path) {"/catalog/sample_ead4"}
  let (:ead_type_path) {"/catalog/sample_ead5"}
  let (:document) { double }

  context "Item" do
    it "links back to the guide" do
      visit ead_item_path
      expect(page).to have_link(I18n.t('exploreuk.ead.guide'), href: ead_path)
    end
  end

  context "Header" do 
    it "displays the author" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.author')
      expect(page).to have_content 'Finding aid prepared by Dorothy Houston'
    end

    it "displays the title" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.title')
      expect(page).to have_content 'Appleton Sturgis papers'
    end

    it "displays the date" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.date')
      expect(page).to have_content '1862-1874'
    end

    it "displays the arrangement" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.arrangement')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Collection is arranged chronologically.'
    end

    it "displays the location note" do
      visit ead_loc_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.location_note')
      expect(page).to have_content 'Housed with multiple collections.'
    end

    it "does not display the location note if unavailable" do
      visit ead_path
      expect(page).to_not have_content I18n.t('exploreuk.ead.header.location_note')
    end

    it "displays the conditions governing access" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.accessrestrict')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Collection is open to researchers by appointment.'
    end

    it "displays the preferred citation note" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.prefercite')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content '1997ms469: [identification of item], Appleton Sturgis papers, 1862-1874, University of Kentucky Special Collections.'
    end

    it "displays the extent" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.extent')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content '0.45 Cubic Feet'
      expect(page).to have_content '72 items'
    end

    it "displays the creator" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.creator')
      expect(page).to have_content 'Sturgis, Appleton, 1842-1900'
    end

    it "displays the abstract" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.abstract')
      expect(page).to have_content 'The Appleton Sturgis papers (dated 1862-1874;'
      expect(page).to have_content 'on a Union transport steamer'
      expect(page).to have_content 'campaign in Virginia and Maryland.'
    end

    it "displays the biography/history" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.bioghist')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Edward Sturgis, and younger sister Kate Sturgis. The family'
      expect(page).to have_content 'six months. His initial duty was as a clerk'
    end

    it "displays the scope and content note" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.scopecontent')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'consist of 70 letters written by Appleton Sturgis, who served'
      expect(page).to have_content 'hand-drawn illustrations and maps. They also include'
      expect(page).to have_content 'letters the work he does on behalf of his father, obtaining charters'
    end

    it "displays the subjects" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.subjects')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Letters.'
      expect(page).to have_content 'Soldiers--Correspondence.'
      expect(page).to have_content 'United States--History--Civil War, 1861-1865--Correspondence.'
    end

    it "displays the use restrictions" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.userestrict')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Property rights reside with the University of Kentucky'
    end

    it "displays related material" do
      visit ead_rel_path
      expect(page).to have_content I18n.t('exploreuk.ead.header.related_material')
      expect(page).to have_xpath '//dd/p'
      expect(page).to have_content 'Bull, Jacqueline.'
      expect(page).to have_content 'The Samuel M. Wilson Library'
      expect(page).to have_content 'Clark, Thomas D.'
      expect(page).to have_content 'The Book Thieves of Lexington: A Reminiscence.'
    end
  end

  context "Collection inventory" do
    it "displays the collection inventory" do
      visit ead_path
      expect(page).to have_content I18n.t('exploreuk.ead.toc.collection_inventory')
    end

    it "displays each c01 series component" do
      visit ead_path
      expect(page).to have_content 'Letter to Captain Russell Sturgis'
      expect(page).to have_content 'Letter to Margaret Sturgis'
      expect(page).to have_content 'Letter to Edward Sturgis'
    end

    it "displays each c02 subseries component" do
      visit ead_subseries_path
      expect(page).to have_content 'Correspondence'
      expect(page).to have_content 'Applications Subseries Box 1 1981-82 (KY'
      expect(page).to have_content 'General'
    end

    it "displays appropriate container lists" do
      visit ead_path
      expect(page).to have_content "Box 1, folder 2"
      visit ead_type_path
      expect(page).to have_content "Box 1, item 5"
    end

    it "displays appropriate browse links" do
      visit ead_path
      expect(page).to have_link(I18n.t('exploreuk.ead.inventory.browse'), href: catalog_path('xt78sf2m7c9x_5_1'))
    end
  end

  context "Table of contents" do
    it "links to the collection inventory" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.toc.collection_inventory')
    end

    it "links to the author" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.author')
    end

    it "links to the title" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.title')
    end

    it "links to the date" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.date')
    end

    it "links to the arrangement" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.arrangement')
    end

    it "links to the location note" do
      visit ead_loc_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.location_note')
    end

    it "does not link to the location note if unavailable" do
      visit ead_path
      expect(page).to_not have_link I18n.t('exploreuk.ead.header.location_note')
    end

    it "links to the conditions governing access" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.accessrestrict')
    end

    it "links to the preferred citation note" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.prefercite')
    end

    it "links to the extent" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.extent')
    end

    it "links to the creator" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.creator')
    end

    it "links to the abstract" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.abstract')
    end

    it "links to the biography/history" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.bioghist')
    end

    it "links to the scope and content note" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.scopecontent')
    end

    it "links to the subjects" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.subjects')
    end

    it "links to the use restrictions" do
      visit ead_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.userestrict')
    end

    it "links to related material" do
      visit ead_rel_path
      expect(page).to have_link I18n.t('exploreuk.ead.header.related_material')
    end
  end
end

def load_sample_documents
  docs = YAML::load(File.open(File.join(File.expand_path("../../fixtures", __FILE__), "sample_solr_documents.yml")))
  Blacklight.solr.add docs
  Blacklight.solr.commit
end
