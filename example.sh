#!/bin/bash
init () {
    cd ~/git-example
    rm -rf example
    git init example
    cd example
    git commit --allow-empty -m "master: initial empty commit"
    git branch f1
    git branch f2
    git branch f3
    clear
}

gitlog () {
    tig
    # git log --oneline --graph
    # read -p "Press key to continue ..." -n1 -s; echo
}

ref0a () {
    init
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  REF 0A: SIMPLE MERGE TO MASTER - NO INTEGRATION TO    ##"
    echo "##  FEATURE BRANCHES                                      ##"
    echo "##                                                        ##"
    echo "############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    for b in 1 2 3; do
        git checkout f$b
        for c in 1 2 3 4; do
            git commit --allow-empty -m "f$b commit $c"
        done
        git checkout master
        git merge --no-edit --no-ff f$b
    done
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
}

ref0b () {
    init
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  REF 0B: SIMPLE MERGE TO MASTER - NO INTEGRATION TO    ##"
    echo "##  FEATURE BRANCHES                                      ##"
    echo "##                                                        ##"
    echo "############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    for c in 1 2 3 4; do
        for b in 1 2 3; do
            git checkout f$b
            git commit --allow-empty -m "f$b commit $c"
            sleep 0.5
        done
    done
    for b in 1 2 3; do
        git checkout master
        git merge --no-edit --no-ff f$b
    done
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    tig --date-order
}

ref1 () {
    init
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  REF 1: REBASE FEATURE BRANCHES ON MASTER              ##" 
    echo "##                                                        ##"
    echo "############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    for b in 1 2 3; do
        git checkout f$b
        git rebase master
        for c in 1 2 3 4; do
            git commit --allow-empty -m "f$b commit $c"
        done
        git checkout master
        git merge --no-edit --no-ff f$b
    done
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
}

issue1 () {
    init
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  ISSUE 1: MERGE MAIN TO FEATURE BRANCHES               ##" 
    echo "##                                                        ##"
    echo "############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    for b in 1 2 3; do
        git checkout f$b
        git merge --no-edit --no-ff master # Issue 1: merge of master
        for c in 1 2 3 4; do
            git commit --allow-empty -m "f$b commit $c"
        done
        git checkout master
        git merge --no-edit --no-ff f$b
    done
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
}

issue2 () {
    init
    echo "############################################################"
    echo "##                                                        ##"
    echo "##  ISSUE 2: MERGE FEATURES TO MAIN ALLOWING FAST-FORWARD ##" 
    echo "##                                                        ##"
    echo "############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    for b in 1 2 3; do
        git checkout f$b
        git rebase master
        for c in 1 2 3 4; do
            git commit --allow-empty -m "f$b commit $c"
        done
        git checkout master
        git merge --no-edit f$b # Issue 2 allowing fast-forward merges to main
    done
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
}

issue3 () {
    init
    echo "#############################################################"
    echo "##                                                         ##"
    echo "##  ISSUE 3+4: DUPLICATE COMMITS AFTER REBASE + SELF MERGE ##" 
    echo "##                                                         ##"
    echo "#############################################################"
    read -p "Press key to continue ..." -n1 -s; echo
    cd ..
    rm -rf remote
    mkdir remote
    cd remote
    git init --bare
    echo $PWD
    cd ../example
    echo $PWD
    git remote add origin ../remote
    git push --set-upstream origin master
    clear
    echo "#############################################"
    echo "##                                         ##"
    echo "##  COMMIT C1,C2,C3,C4 TO MASTER AND PUSH  ##" 
    echo "##                                         ##"
    echo "#############################################"
    for c in 1 2 3 4; do
        git commit --allow-empty -m "commit $c"
    done
    git push
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  COMMIT C5,C6 TO F4 AND PUSH            ##" 
    echo "##                                         ##"
    echo "#############################################"
    git checkout -b f4
    for c in 5 6; do
        echo "commit $c" >> readme.txt
        git add readme.txt
        git commit -m "commit $c"
    done
    git push --set-upstream origin f4
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  SWITCH TO MASTER AND COMMIT C7         ##" 
    echo "##                                         ##"
    echo "#############################################"
    git checkout master
    git commit --allow-empty -m "commit 7"
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  SWITCH BACK TO F4 AND REBASE ON MASTER ##" 
    echo "##                                         ##"
    echo "#############################################"
    git checkout f4
    git rebase master
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  TRY TO PUSH F4 AND OBSERVE ERROR       ##" 
    echo "##                                         ##"
    echo "#############################################"
    git push
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  FOLLOW GIT ADVICE AND PULL BEFORE PUSH ##" 
    echo "##                                         ##"
    echo "#############################################"
    git pull
    git push
    read -p "Press key to continue ..." -n1 -s; echo
    gitlog
    read -p "Press key to continue ..." -n1 -s; echo
    echo "#############################################"
    echo "##                                         ##"
    echo "##  USE REFLOG TO RESET TO BEFORE PULL     ##" 
    echo "##  AND DO: git push -f                    ##"
    echo "#############################################"
    read -p "Press key to continue ..." -n1 -s; echo
}

# ref0a
# ref0b
# ref1
# issue1
# issue2
issue3

