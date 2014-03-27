require File.expand_path(File.dirname(__FILE__) + '/../boot')

class HerbariumControllerTest < FunctionalTestCase
  def test_show_herbarium
    nybg = herbaria(:nybg)
    assert(nybg)
    get_with_dump(:show_herbarium, :id => nybg.id)
    assert_response('show_herbarium')
  end

  def show_herbarium_params
    {
      :id => herbaria(:nybg).id,
      :curator => {
        :name => users(:mary).login
      }
    }
  end
  
  def test_show_herbarium_post
    login('rolf')
    params = show_herbarium_params
    herbarium = Herbarium.find(params[:id])
    curator_count = herbarium.curators.count
    post(:show_herbarium, params)
    assert_equal(curator_count+1, Herbarium.find(params[:id]).curators.count)
    assert_response(:success)
  end

  def test_index
    get_with_dump(:index)
    assert_response('index')
  end
  
  def test_create_herbarium
    get(:create_herbarium)
    assert_response(:redirect)

    login('rolf')
    get_with_dump(:create_herbarium)
    assert_response('create_herbarium')
  end
  
  def create_herbarium_params
    return {
      :herbarium => {
        :name => "Rolf's Personal Herbarium",
        :description => 'Rolf wants Melanolucas!!!',
        :email => rolf.email,
        :mailing_address => "",
        :place_name => "",
        :code => "RPH"
      }
    }
  end
  
  def test_create_herbarium_post
    login('rolf')
    params = create_herbarium_params
    post(:create_herbarium, params)
    herbarium = Herbarium.find(:all, :order => "created_at DESC")[0]
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_equal(params[:herbarium][:code], herbarium.code)
    assert_equal([rolf], herbarium.curators)
    assert_response(:redirect)
  end
  
  def test_create_herbarium_post_with_duplicate_name
    login('rolf')
    params = create_herbarium_params
    params[:herbarium][:name] = herbaria(:nybg).name
    post(:create_herbarium, params)
    assert_flash(/already exists/i)
    herbarium = Herbarium.find(:all, :order => "created_at DESC")[0]
    assert_not_equal(params[:herbarium][:description], herbarium.description)
    assert_response(:success) # Really means we go back to create_herbarium without having created one.
  end
  
  def test_create_herbarium_post_no_email
    login('rolf')
    params = create_herbarium_params
    params[:herbarium][:email] = ""
    post(:create_herbarium, params)
    assert_flash(/email address is required/i)
    herbarium = Herbarium.find(:all, :order => "created_at DESC")[0]
    assert_not_equal(params[:herbarium][:name], herbarium.name)
    assert_response(:success)
  end
  
  def test_create_herbarium_post_with_existing_place_name
    login('rolf')
    params = create_herbarium_params
    params[:herbarium][:place_name] = locations(:nybg).name
    post(:create_herbarium, params)
    herbarium = Herbarium.find(:all, :order => "created_at DESC")[0]
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_equal(locations(:nybg), herbarium.location)
    assert_response(:redirect)
  end
  
  def test_create_herbarium_post_with_nonexisting_place_name
    login('rolf')
    params = create_herbarium_params
    params[:herbarium][:place_name] = "Somewhere over the rainbow"
    post(:create_herbarium, params)
    herbarium = Herbarium.find(:all, :order => "created_at DESC")[0]
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_nil(herbarium.location)
    assert_response(:redirect)
  end

  def test_edit_herbarium
    nybg = herbaria(:nybg)
    get_with_dump(:edit_herbarium, :id => nybg.id)
    assert_response(:redirect)

    login('mary') # Non-curator
    get_with_dump(:edit_herbarium, :id => nybg.id)
    assert_flash(/non-curator/i)
    assert_response(:redirect)

    login('rolf')
    get_with_dump(:edit_herbarium, :id => nybg.id)
    assert_response('edit_herbarium')

    make_admin('mary') # Non-curator but an admin
    get_with_dump(:edit_herbarium, :id => nybg.id)
    assert_response('edit_herbarium')
  end
  
  def test_edit_herbarium_post
    login('rolf')
    nybg = herbaria(:nybg)
    params = create_herbarium_params
    params[:id] = nybg.id
    post(:edit_herbarium, params)
    herbarium = Herbarium.find(nybg.id)
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_nil(herbarium.location)
    assert_response(:redirect)
  end
  
  def test_edit_herbarium_post_with_duplicate_name
    login('rolf')
    nybg = herbaria(:nybg)
    rolf = herbaria(:rolf)
    params = create_herbarium_params
    params[:id] = nybg.id
    params[:herbarium][:name] = rolf.name
    post(:edit_herbarium, params)
    herbarium = Herbarium.find(nybg.id)
    assert_equal(nybg.name, herbarium.name)
    assert_flash(/already exists/i)
    assert_response(:success)
  end
  
  def test_edit_herbarium_post_no_name_change
    login('rolf')
    nybg = herbaria(:nybg)
    params = create_herbarium_params
    params[:herbarium][:name] = nybg.name
    params[:id] = nybg.id
    post(:edit_herbarium, params)
    herbarium = Herbarium.find(nybg.id)
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_nil(herbarium.location)
    assert_response(:redirect)
  end

  def test_edit_herbarium_post_no_email
    login('rolf')
    nybg = herbaria(:nybg)
    params = create_herbarium_params
    params[:id] = nybg.id
    params[:herbarium][:email] = ""
    post(:edit_herbarium, params)
    assert_flash(/email address is required/i)
    herbarium = Herbarium.find(nybg.id)
    assert_not_equal(params[:herbarium][:email], herbarium.email)
    assert_response(:success)
  end
  
  def test_edit_herbarium_post_with_existing_place_name
    login('rolf')
    nybg = herbaria(:nybg)
    params = create_herbarium_params
    params[:id] = nybg.id
    params[:herbarium][:place_name] = locations(:salt_point).name
    post(:edit_herbarium, params)
    herbarium = Herbarium.find(nybg.id)
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_equal(locations(:salt_point), herbarium.location)
    assert_response(:redirect)
  end
  
  def test_edit_herbarium_post_with_nonexisting_place_name
    login('rolf')
    nybg = herbaria(:nybg)
    params = create_herbarium_params
    params[:id] = nybg.id
    params[:herbarium][:place_name] = "Somewhere over the rainbow"
    post(:edit_herbarium, params)
    herbarium = Herbarium.find(nybg.id)
    assert_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(params[:herbarium][:description], herbarium.description)
    assert_equal(params[:herbarium][:email], herbarium.email)
    assert_equal(params[:herbarium][:mailing_address], herbarium.mailing_address)
    assert_nil(herbarium.location)
    assert_response(:redirect)
  end
  
  def test_edit_herbarium_post_by_non_curator
    login('mary')
    nybg = herbaria(:nybg)
    old_name = nybg.name
    params = create_herbarium_params
    params[:id] = nybg.id
    post(:edit_herbarium, params)
    assert_flash(/non-curator/i)
    herbarium = Herbarium.find(nybg.id)
    assert_not_equal(params[:herbarium][:name], herbarium.name)
    assert_equal(old_name, herbarium.name)
    assert_response(:redirect)
  end
  
  def delete_curator_params
    {
      :id => herbaria(:nybg).id,
      :user => users(:roy).id
    }
  end
  
  def test_delete_curator
    login('rolf')
    params = delete_curator_params
    herbarium = Herbarium.find(params[:id])
    curator_count = herbarium.curators.count
    post(:delete_curator, params)
    assert_equal(curator_count-1, Herbarium.find(params[:id]).curators.count)
    assert_response(:redirect)
  end
  
  def test_delete_curator_you_not_curator
    login('mary')
    params = delete_curator_params
    herbarium = Herbarium.find(params[:id])
    curator_count = herbarium.curators.count
    post(:delete_curator, params)
    assert_equal(curator_count, Herbarium.find(params[:id]).curators.count)
    assert_flash(/are not a curator/)
    assert_response(:redirect)
  end
  
  def test_delete_curator_you_admin
    make_admin('mary')
    params = delete_curator_params
    herbarium = Herbarium.find(params[:id])
    curator_count = herbarium.curators.count
    post(:delete_curator, params)
    assert_equal(curator_count-1, Herbarium.find(params[:id]).curators.count)
    assert_response(:redirect)
  end
  
  def test_delete_curator_they_not_curator
    login('rolf')
    params = delete_curator_params
    params[:user] = users(:mary).id
    herbarium = Herbarium.find(params[:id])
    curator_count = herbarium.curators.count
    post(:delete_curator, params)
    assert_equal(curator_count, Herbarium.find(params[:id]).curators.count)
    assert_flash(/is not a curator/)
    assert_response(:redirect)
  end
end
