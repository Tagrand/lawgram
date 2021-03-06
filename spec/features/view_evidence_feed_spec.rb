require 'rails_helper'

feature 'evidence feed' do
   background do
     statement_one = create(:statement, evidence: 'This is the first')
     statement_two = create(:statement, evidence: 'This is the second')
     visit '/'
   end

  scenario 'displays multiple statements' do
    expect(page).to have_content('This is the first')
    expect(page).to have_content('This is the second')
    expect(page).to have_css('img[src*="lawyer.jpg"]')
  end

  scenario 'visit an individual statement' do
     page.all(:link, "See evidence")[1].click
     expect(page).not_to have_content('This is the first')
     expect(page).to have_content('This is the second')
     expect(page).to have_css('img[src*="lawyer.jpg"]')
  end

  scenario 'edit a file' do
    page.all(:link, "Tamper")[1].click
    attach_file('statement[image]', 'spec/files/images/lawyer2.jpg')
    fill_in :Evidence, with: 'Ouch...this is not good'
    click_button 'Permanently change'
    expect(page).to have_content('Evidence changed mate')
    expect(page).to have_content('Ouch...this is not good')
    expect(page).to have_css('img[src*="lawyer2.jpg"]')
    expect(page).not_to have_content('This is the second')
    expect(page).not_to have_css('img[src*="lawyer.jpg"]')
  end

  scenario 'delete a post' do
    page.all(:link, "Destroy Evidence")[1].click
    expect(page).not_to have_content('This si the second')
    expect(page).to have_content('Evidence destroyed')
    expect(page).to have_content('This is the first')
  end
end
