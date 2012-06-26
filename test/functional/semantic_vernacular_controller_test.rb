require File.expand_path(File.dirname(__FILE__) + '/../boot')

class SemanticVernacularControllerTest < FunctionalTestCase
  
  def test_index_vernaculars
    get_with_dump(:index_vernaculars) 
    assert_response('index_vernaculars')
    assert_not_nil(assigns(:all_vernaculars))
  end

  def test_index_species
  	get_with_dump(:index_species)
  	assert_response('index_species')
  	assert_not_nil(assigns(:all_species))
  end

  def test_show_vernacular
  	get_with_dump(:show_vernacular, :uri => "http://aquarius.tw.rpi.edu/ontology/fungi.owl#PineSpike")
  	assert_response("show_vernacular")
  	assert_not_nil(assigns(:vernacular))
  end

  def test_show_species
  	get_with_dump(:show_species, :uri => "http://aquarius.tw.rpi.edu/ontology/fungi.owl#ChroogomphusOchraceus")
  	assert_response("show_species")
  	assert_not_nil(assigns(:species))
  end

end
