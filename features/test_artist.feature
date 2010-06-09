Feature: Test Artist
  In order to know which artists are available
  As a user
  I want to view the artists from each letter

  Scenario: View Artists Songs
    Given I have an artist named artist
    When I go to an artist letter page
    Then I should see artist.name
