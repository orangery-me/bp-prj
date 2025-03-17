# Blood Pressure [APP]

## Clone Project

Step 1: Clone the project by git@gitlab.com:bkdn-tech-team-1/blood-pressure.git<br />
Step 2: TODO...

## Git Flow

- Step 1: Update status of task in [Gitlab Issues](https://gitlab.com/bkdn-tech-team-1/blood-pressure/-/issues)
- Step 2: checkout to `develop`, pull newest code from `develop`
  ```
  git checkout develop
  git pull origin develop
  ```
- Step 3: Create branch for task, base in branch `develop`

  **Rule of branch name:**

  - branch name start with `task/`
  - After that, concat with string `bp-[issueId]`
  - End of branch name with issue's brief `-[issue-brief]`

  Example: issue's Id is 1, Name is `init base source`. Branch name is `task/bp-1-init-base-source`

  ```
  git checkout -b task/bp-1-init-base-source
  ```

- Step 4: When commit, message of commit follow rule

  - branch name start with `task: `
  - Next is string `[BP-[issueId]]`
  - Next is commit content

  Example: `task: [BP-1] Init Base Source`

- Step 5: When create merge request

  **Rule of merge request name:**

  - Start with `[BP-[issueId]]`
  - Next is merge request content

    Example: `[BP-1] Init Base Source`

  **Rule of merge request description:**

  - In **`What does this MR do and why?`**, replace _`Describe in detail what your merge request does and why.`_ with your content of this merge request
  - In **`Screenshots or screen recordings`**, replace _`These are strongly recommended to assist reviewers and reduce the time to merge your change.`_ with screen recordings of feature or task for this merge request
  - Check the checklist
  - Select approver
  - Select merger

- Note:
  - If have conflict with branch `develop` or need to get newest code from branch `develop`
  - Create other branch with convention like step 3. But have suffixes `-dev`, `-dev1`,... (in example, branch name is `task/bp-1-dev`)
  - After that, merge coding branch to new branch. In example is merger branch `task/bp-1` to branch `task/bp-1-dev`
  - Fix conflict and create merge request from `task/bp-1-dev` to `develop`

## Project Structure

    - TO DO

## Run project

    - TODO

## Use visual studio code

### Extensions

    - TODO

## Note
