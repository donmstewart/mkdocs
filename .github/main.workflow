workflow "DockerPS MkDocs" {
  on = "push"
  resolves = ["deploy"]
}

action "is-branch-master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "is-not-branch-deleted" {
  uses = "actions/bin/filter@master"
  args = "not deleted"
}

action "build" {
  needs = ["is-branch-master", "is-not-branch-deleted"]
  uses = "donstewart/mkdocs@1.0.4"
  args = ["build"]
}

action "deploy" {
  needs = "build"
  uses = "donstewart/mkdocs@1.0.4"
  env = {
    PUBLISH_DIR = "./_site"
    PUBLISH_BRANCH = "gh-pages"
  }
  secrets = ["GITHUB_TOKEN"]
}