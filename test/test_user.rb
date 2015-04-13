require 'test_helper'

class User < Minitest::Test
  
  def setup
    @user = {email: "watson@example.com", zimbraId: "251b1902-2250-4477-bdd1-8a101f7e7e4e"}
  end
  
  def test_only_set_zimbraId_when_passed_a_zimbraId
    u = ZimbraInterceptingProxy::User.new(@user[:zimbraId])
    assert_equal(u.zimbraId, @user[:zimbraId])
    assert_nil(u.email)
  end
  
  def test_only_set_email_when_passed_an_email
    u = ZimbraInterceptingProxy::User.new(@user[:email])
    assert_equal(u.email, @user[:email])
    assert_nil(u.zimbraId)
  end
  
  def test_return_email_when_passed_just_an_username
    u = ZimbraInterceptingProxy::User.new("watson")
    assert_equal(u.email, @user[:email])
    assert_nil(u.zimbraId)
  end
  
  def test_should_load_db_user_file_to_global_hash
    assert_equal(ZimbraInterceptingProxy::User.DB.class, Hash)
  end
  
  def test_db_should_have_emails_when_email_is_passed
    assert(ZimbraInterceptingProxy::User.DB["watson@example.com"])
  end

  def test_return_true_if_migrated_user_with_zimbraId
    u = ZimbraInterceptingProxy::User.new("7b562ce0-be97-0132-9a66-482a1423458f")
    assert(u.migrated?, "Failure message.")
  end
  
  def test_return_false_if_not_migrated_user_with_zimbraId
    u = ZimbraInterceptingProxy::User.new("7b562ce0-be97-0132-9a66-482a14234333")
    assert(!u.migrated?, "Failure message.")
  end
  
  def test_return_true_if_migrated_user_with_email
    u = ZimbraInterceptingProxy::User.new(@user[:email])
    assert(u.migrated?, "Failure message.")
  end
  
  def test_return_false_if_no_migrated_user_with_email
    u = ZimbraInterceptingProxy::User.new("pbruna")
    assert(!u.migrated?, "Failure message.")
  end
  
end