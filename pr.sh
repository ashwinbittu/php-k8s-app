echo "Opening a Pull Request"

#curl -X 'POST' \
#  'http://139.59.21.103:3000/api/v1/repos/siddharth/gitops-argocd/pulls' \
#  -H 'accept: application/json' \
#  -H "authorization: $ARGOCD_TOKEN" \
#  -H 'Content-Type: application/json' \
#  -d '{
#  "assignee": "siddharth",
#  "assignees": [
#    "siddharth"
#  ],
#  "base": "main",
#  "body": "Updated deployment specification with a new image version.",
#  "head": "feature-gitea",
#  "title": "Updated Solar System Image"
#}'

echo $GITHUB_TOKEN | gh auth login --with-token
gh pr create --assignee "@me" --base "main" --title "Updated PHP k8s App" --body "Updated deployment specification with a new image version."

echo "Success"
