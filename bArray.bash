#!/bin/bash

#for regex-like searching in case statement
shopt -s extglob;

#iterate through all the arguments
for arg in $@; do
    case "$arg" in
        "length" | "append" | "list" | remove-+([0-9])- | get-+([0-9])- | replace-+([0-9])-)
            #set the operation
            operation=$arg
            ;;
        -*-)
            #get the string
            item="$arg"
            ;;
        *)
            if echo "$arg" | grep -E '\[".*",' | grep -qE '",]'; then
                #get the array
                array="$arg"
            fi
            ;;
    esac
done

function reconstruct() {
    #turn newline-separated list into
    #  the array format
    printf "$1" | \
        sed 's|^|"|g' | \
        sed 's|$|",|g' | \
        sed -z "s|,\n|,|g" | \
        sed 's|$|]|' | \
        sed 's|^|\[|'
}

function list() {
    #print the items in the array
    #  as a newline separated list
    echo "$1" | \
        sed 's|^\["||g' | \
        sed 's|",]$||g' | \
        sed 's|",|\n|g' | \
        sed 's|^"||g'
}

function length() {
    #print the items as newline
    #  list then count number of
    #    lines
    list "$1" | \
        wc -l
}

function replace() {
    #get the new item from input
    local newItem=$(echo $2 | \
        sed 's|^-||' | \
        sed 's|-$||')
    #get the desired index
    local index=$(echo "$1" | \
        sed 's|replace-||' | \
        sed 's|-$||')
    #construct new list with item
    #  in the index replaced
    local newList=$(list "$array" | \
        sed "${index}c\\${newItem}")
    #convert back into array
    reconstruct "$newList"
}

function get() {
    #get the desired index
    local index=$(echo "$1" | \
        sed 's|get-||' | \
        sed 's|-$||')
    #newline list of items then
    #  get the selected line from
    #    index
    list "$2" | \
        sed -n "${index}p"
}

function remove() {
    #get the desired index
    local index=$(echo "$1" | \
        sed 's|remove-||' | \
        sed 's|-$||')
    #get the value of line from index
    local line="$(get ${index} ${2})"
    #newline list of items then
    #  replace line from index
    local newList=$(list "${2}" | \
        sed "/^${line}$/d")
    #rebuild as array
    reconstruct "$newList"
}

function append() {
    #get the new item
    local newItem=$(echo "$2" | \
        sed 's|^-||' | \
        sed 's|-$||')
    #newline list of items then
    #  echo the new item at the end
    local newList=$(list "$1" && echo "$newItem")
    #turn back into array
    reconstruct "$newList"
}

#if the array isn't provided or is empty
if [[ -z $array ]]; then
    echo "no array detected"
    echo "valid format: '[\"foo\",]'"
else #otherwise...
    case "$operation" in
        "length") #if length, run length fn
            length "$array"
            ;;
        "append") #if append, run append fn
            append "$array" "$item"
            ;;
        "list") #if list, run list fn
            list $array
            ;;
        remove-+([0-9])-) #if remove, run remove fn
            remove "$operation" "$array"
            ;;
        get-+([0-9])-) #if get, run get fn
            get "$operation" "$array"
            ;;
        replace-+([0-9])-) #if replace run replace fn
            replace "$operation" "$item"
            ;;
        *) #if all else fails, then the user did something
           #  wrong (probably, maybe, possibly, hopefully)
            echo "invalid operation"
            ;;
    esac
fi
