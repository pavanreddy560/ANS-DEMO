change_version(){
  
  sed -i "s/$1/$2/1" $3
  
}

change_version $1 $2 $3
