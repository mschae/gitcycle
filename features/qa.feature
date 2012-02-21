Feature: QA

Scenario: QA issue
  Given a fresh set of repositories
  When I cd to the user repo
    And I execute gitcycle branch with a new URL or string
    And I give default input
    And gitcycle runs
    And I commit something
    And I execute gitcycle with "ready"
    And gitcycle runs
    And I cd to the owner repo
    And I checkout master
    And I execute gitcycle with "qa issue.id"
    And I enter "y"
    And gitcycle runs
  Then output includes
    """
    Do you want to create a QA branch from 'master'? (y/n)
    Retrieving branch information from gitcycle.
    Adding remote repo 'config.owner/config.repo'.
    Fetching remote 'config.owner'.
    Checking out remote branch 'qa_master_config.user' from 'config.owner/config.repo/master'.
    Fetching remote 'origin'.
    Pushing 'origin/qa_master_config.user'.
    Adding remote repo 'config.user/config.repo'.
    Fetching remote 'config.user'.
    Merging remote branch 'ticket.id' from 'config.user/config.repo'.
    Pushing branch 'qa_master_config.user'.
    Type 'gitc qa pass' to approve all issues in this branch.
    Type 'gitc qa fail' to reject all issues in this branch.
    """

Scenario: QA issue pass w/ issue number
  Given a fresh set of repositories
  When I cd to the user repo
    And I execute gitcycle branch with a new URL or string
    And I give default input
    And gitcycle runs
    And I commit something
    And I execute gitcycle with "ready"
    And gitcycle runs
    And I cd to the owner repo
    And I checkout master
    And I execute gitcycle with "qa issue.id"
    And I enter "y"
    And gitcycle runs
    And I checkout qa_master_config.user
    And I execute gitcycle with "qa pass issue.number"
    And gitcycle runs with exit
  Then output includes
    """
    Retrieving branch information from gitcycle.
    Checking out branch 'master'.
    You cannot pass individual issues. You must pass the entire QA branch.
    Please run 'gitc qa pass' to pass the entire QA branch.
    """

Scenario: QA issue pass
  When I cd to the owner repo
    And I checkout qa_master_config.user
    And I execute gitcycle with "qa pass"
    And gitcycle runs
  Then output includes
    """
    Retrieving branch information from gitcycle.
    Checking out branch 'master'.
    Adding remote repo 'config.owner/config.repo'.
    Fetching remote 'config.owner'.
    Merging remote branch 'qa_master_config.user' from 'config.owner/config.repo'.
    Pushing branch 'master'.
    Labeling all issues as 'Pass'.
    """

Scenario: QA issue list
  When I cd to the owner repo
    And I checkout master
    And I execute gitcycle with "qa"
    And gitcycle runs
  Then output includes
    """
    qa_master_config.user
      issue #issue.id\tconfig.user/last_ticket.id
    """