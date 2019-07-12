

'''This script walks through promoting a model in FastScore
For two environments in FastScore, we can et each environment to be backed by a separate branch in Git. 
For our example, we will be using develop and master for the two environmetns, and merge develop into master.
Therefore, it is straightfoward to merge the branches using these commands:
'''

git checkout master
git merge develop

'''This can also be accomplished using a pull request via Bitbucket/ Github if they are required'''