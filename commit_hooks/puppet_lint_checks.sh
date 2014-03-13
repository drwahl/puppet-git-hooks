#!/bin/sh                                                                                                                                                      
                                                                                                                                                               
git_root=`git rev-parse --show-toplevel`                                                                                                                       
syntax_errors=0                                                                                                                                                
                                                                                                                                                               
# Get list of new/modified manifest and template files to check (in git index)                                                                                 
for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep '\.*.pp$\|\.*.erb$'`                                                               
do                                                                                                                                                             
    # Don't check empty files                                                                                                                                  
    case $puppetmodule in                                                                                                                                      
        *.pp )                                                                                                                                                 
            # Check puppet manifest syntax                                                                                                                     
            puppet parser validate --color=false $git_root/$puppetmodule ;;                                                                                    
        *.erb )                                                                                                                                                
            # Check ERB template syntax                                                                                                                        
            cat $git_root/$puppetmodule | erb -x -T - | ruby -c > /dev/null ;;                                                                                 
    esac                                                                                                                                                       
    if [ $? -ne 0 ]; then                                                                                                                                      
        echo -n "$indexfile: "                                                                                                                                 
        syntax_errors=`expr $syntax_errors + 1`                                                                                                                
        echo "ERROR in $puppetmodule (see above)"                                                                                                              
    fi                                                                                                                                                         
done                                                                                                                                                           
                                                                                                                                                               
if [ "$syntax_errors" -ne 0 ]; then                                                                                                                            
    echo "Error: $syntax_errors syntax errors found, aborting commit."                                                                                         
    exit 1                                                                                                                                                     
fi

exit 0
dwahlstrom@ubuntu:~/git/puppet/.git/hooks/commit_hooks [rspec-tests $] $ cat puppet_lint_checks.sh 
#!/bin/sh

git_root=`git rev-parse --show-toplevel`

syntax_errors=0

# De-lint puppet manifests
if [ `which puppet-lint` ]; then
    for puppetmodule in `git diff --cached --name-only --diff-filter=ACM | grep \.*.pp$`; do
        puppet-lint --fail-on-warnings --with-filename --no-80chars-check --no-double_quoted_strings-check $git_root/$puppetmodule
        RC=$?
        if [ $RC -ne 0 ]; then
            exit $RC
        fi
    done
fi

exit 0
