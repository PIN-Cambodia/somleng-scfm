# Contributing

Follow this guide on how to contribute code to this repository.

## Branching

As we wish to keep the `develop` working at all times, pleasse create a new branch for your changes, and submit a pull request once everything is working as expected. To do this, follow the following steps:

    git checkout -b <new-branch-name> develop
    git push origin <new-branch-name>

Now, this new branch is on your computer as well as git. You can work on this as you'd normally do.

## Testing

Before pushing your code changes, please make sure to run the test suite, ensuring that nothing breaks. To do this, run the following:

Since we're using selenium for some of the tests, we need to fire up a chrome headless browser in selenium to properly run all the tests. In order to do this, use the following command to start up `docker-compose` instead of the normal one:

    docker-compose -f docker-compose.yml -f docker-compose-selenium.yml up

And then from the same directory, attach to the docker container with bash:

    docker exec -it somleng-scfm_somleng-scfm_1 bash

If this is your first time running tests, we need to make sure that the database exists:

    DATABASE_URL=postgres://postgres:@db/somleng_scfm_test RAILS_ENV=test ./bin/rails db:setup

Followed by the actual test suite:

    SELENIUM_REMOTE_HOST=selenium DATABASE_URL=postgres://postgres:@db/somleng_scfm_test RAILS_ENV=test rake

This takes about 5-10 mins to run, so it's a good chance to grab a coffee! If you do not see any failures in the test, you're ready to commit your changes

## Committing and creating a pull request

Commit your changes as normal with git, and then go to https://github.com/PIN-Cambodia/somleng-scfm/pulls to create a new pull request. You want to create this with develop as the target (the first dropdown) and your new branch as the source (the second dropdown). As you do this, all the automated testing will run again, and if this passed, anyone with admin access to the github repo will be able to approve the pull request.
