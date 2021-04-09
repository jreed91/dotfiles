
gha() {                                                                                                                         
    remotes=$(git remote -v | head -n 1 | awk -F " " '{print $2}' | sed 's/\.git//g' | awk '{print $1"/actions"}')         
    echo "Opening browser to" $remotes                                                                                      
    echo $remotes | xargs start
} 

git_current_branch () {
    local ref                                                                                                              
    ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)                                                              
    local ret=$?                                                                                                            
    if [[ $ret != 0 ]]                                                                                                      
    then                                                                                                                           
        [[ $ret == 128 ]] && return                                                                                            
        ref=$(command git rev-parse --short HEAD 2> /dev/null)  || return                                              
    fi                                                                                                                      
    echo ${ref#refs/heads/}                                                                                         
}                                                                               
             

alias gpo='git pull origin'                                                                                            
alias gpl='git pull'
alias gpu='git push origin "$(git_current_branch)"'                                                                     
alias gc='git commit'                                                                                                   
alias gco='git checkout'                                                                                                
alias gfa='git fetch --all'                                                           
alias gcm='gfa && git checkout master && gpl'                    
alias python=python3   
