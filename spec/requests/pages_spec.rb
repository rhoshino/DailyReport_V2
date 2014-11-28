describe "Pages" do

  subject{ page }

  shared_examples_for "all pages"do
    it{is_expected.to have_content(heading)}
  end

  describe "Home page" do
    before{visit root_path}
    let(:heading){'日報アプリケーション'}

    it_should_behave_like("all pages")

    describe "for Signed-in users" do
      let(:user){FactoryGirl.create(:user)}

      before do
        sign_in  user
        visit root_path
      end

      it{is_expected.to have_link('Home')}
      it{is_expected.to have_link('Account')}
      it{is_expected.to have_link('Profile')}
      it{is_expected.to have_link('Settings')}
      it{is_expected.to have_link('Sign out')}

      it "try to Sign out" do
        click_link('Sign out')
        is_expected.to have_content("Sign in")
      end

    end#for Signed-in users
  end# Home page

  describe "Sign up Page" do

    before{ visit new_user_registration_path }

    it{is_expected.to have_content('Sign up')}
  end# Sign up page

    describe "Sign up Session" do
      before {visit new_user_registration_path}

      let(:submit){"Create Account"}

      describe "with Invalid information" do
        describe "after submission" do
          before{click_button submit}

          it{ is_expected.to have_content('Sign up')}
          it{ is_expected.to have_content("error")}
        end
      end#with Invalid information

      describe "with Valid information" do

        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "password"
          fill_in "Password confirmation", with: "password"
        end

        describe "after saving the user" do
          before{click_button submit}

          it {is_expected.to have_link('Sign out')}
          it {is_expected.to have_selector('div.alert.alert-notice', text:'Welcome!')}

          it "and redirect root, vanish flash massage" do
            visit root_path
            is_expected.not_to have_selector('div.alert.alert-notice', text:'Welcome!')
          end

        end# after saving the user

      end# with Valid information
    end#Sign up Session

    describe "Edit page" do
      let (:user){FactoryGirl.create(:user)}
      before do
        sign_in user
        visit edit_user_registration_path(user)
      end

      describe "page" do
        it{is_expected.to have_content("Edit User")}
      end

      describe "with valid information" do
        let(:new_name){"New Name"}
        let(:new_email){"new@example.com"}

        before do
          fill_in "Name",                  with: new_name
          fill_in "Email",                 with: new_email
          fill_in "Password",              with: user.password
          fill_in "Password confirmation", with: user.password
          click_button "Update"
        end

        it{is_expected.to have_content(new_name)}
        it{is_expected.to have_selector('div.alert.alert-notice', text:'success')}
        it{is_expected.to have_link('Sign out')}

        specify { expect(user.reload.name).to eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end# with Valid information

    end

end