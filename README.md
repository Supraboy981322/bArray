# bArray
I felt like writing my own implementation of arrays in Bash
---
## Recommended Install Method:
1) Download `bArray.bash`
   ```shell
   curl -O https://raw.githubusercontent.com/Supraboy981322/bArray/main/bArray.bash
   ```
2) Move it to a directory of your choice (ex: `/etc/scripts/`, this directory may require `su` permissions) and rename it to `bArray` (remove `.bash` from the end)
   ```shell
   mv bArray.bash /etc/scripts/bArray
   ```
3) Make it executable (may require `su` permissions)
   ```shell
   chmod a+x /etc/scripts/bArray
   ```
3) Add your chosen directory to your system-wide `$PATH` (replace `/etc/scripts` with your directory and `/etc/bash.bashrc` with your shell's equivalent)
   ```shell
   echo 'PATH=$PATH:/etc/scripts' >> /etc/bash.bashrc
   ```
---
## Usage:
> [!NOTE]
> bArray is non-zero based (`1` is the first item).
### Formatting
  ```
  ["foo","bar","baz",]
  ```
  So, if you were to `echo` it:
  ```shell
  echo '["foo","bar","baz",]'
  ```
### Listing an array
  ```shell
  bArray list '["foo","bar","baz",]'
  ```
  Which returns
  ```
  foo
  bar
  baz
  ```
### Getting the length of an array
  ```shell
  bArray length '["foo","bar","baz",]'
  ```
  Which returns
  ```
  3
  ```
### Appending to an array
  ```shell
  bArray append '-qux-' '["foo","bar","baz",]'
  ```
  Which returns
  ```
  ["foo","bar","baz","qux",]
  ```
### Removing from an array
  If you want to remove the 2nd item:
  ```shell
  bArray remove-2- '["foo","bar","baz",]'
  ```
  returns
  ```
  '["foo","baz",]'
  ```
### Getting a value from an array
  If you want to get the second value:
  ```shell
  bArray get-2- '["foo","bar","baz",]'
  ```
  Which returns
  ```
  bar
  ```
### Replacing a value
  If you wan to replace the 2nd value
  ```shell
  bArray replace-2- '-qux-' '["foo","bar","baz",]'
  ```
  Which returns
  ```
  '["foo","qux","baz",]'
  ```
