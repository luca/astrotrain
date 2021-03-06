require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe LoggedMail do
  describe "being created from Message" do
    before :all do
      User.all.destroy!
      Mapping.all.destroy!
      @user    = User.create!(:login => 'user')
      @mapping = @user.mappings.create!(:user_id => @user.id, :email_user => '*', :recipient_header_order => 'delivered_to,original_to,to')
      @raw     = mail(:custom)
      @message = Message.parse(@raw)
      @message.filename = 'logged_mail_raw'
      @logged  = LoggedMail.from(@message) do |l|
        l.set_mapping(@mapping)
      end
      File.open @logged.raw_path, 'w' do |f|
        f << @raw
      end
    end

    it "sets recipient" do
      @logged.recipient.should == @message.recipient(%w(delivered_to))
    end

    it "sets subject" do
      @logged.subject.should == @message.subject
    end

    it "sets mapping" do
      @logged.mapping.should == @mapping
    end

    it "sets raw headers" do
      @logged.raw.should == @raw
    end
  end
end