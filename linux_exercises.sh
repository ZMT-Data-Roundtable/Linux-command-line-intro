##########################
#   Linux command line   #
##########################

# This tutorial will only cover the basics to give you a better idea how to google for the best solutions.


### Accessing the terminal

# Windows: no server connection --> use git bash (or any other emulator)
# Windows: with server access --> use PuTTY (shh) to connect to server
# Mac + Linux: Open terminal --> optional: connect to server with: ssh user@server



### Your home directory

# Navigate to your home directory
cd ~

# Show where you are (may also be part of command prompt)
pwd

# List contents of directory
ls

# Look at ls options in man pages
man ls

# Task: Show hidden files.
# Task: Show detailed file (and directory) information. What does detailed information mean?
# Task: List directory contents by date last modified.
# Task: List directory contents sorted by file size (human readable output).

# navigation shortcuts
cd .
cd ..
cd ~

# Task: What is the difference between absolute and relative paths?

# If you are logged on to a server, there should be a hidden file called .bashrc and/or .bash_profile
# This file contains commands to configure your session, e.g. colored ls output

# Task: What are the contents of your .bashrc?
# Task: Modify your .bashrc to show colored ls output (using default text editor vi).



### The $PATH

# The $PATH tells the computer where to look for programs
echo $PATH

# You can spefiy the $PATH in your .bashrc

# To flexibly modify your path and switch between different versions of the same program: use modules
# module load/unload will add/remove program locations from your $PATH



### Creating directories

# Create directory for this tutorial and enter it
mkdir Test_dir
cd ./Test_dir/



### Standard input/output/error, redirect and pipe, wildcards

# create dummy file without content
touch test1.txt

# manual text input (redirected to file)
cat > test2.txt
# enter text
# ctrl + C

# CAUTION for Windows users: crtl + C is not copy, but kill!
# naming conventions: NO SPACES OR SPECIAL CHARACTERS IN FILE AND DIRECTORY NAMES!!!

# Task: Save the list of contents of your directory in a text file.

# Combining commands (pipe: |)
# Task: Count the contents of your directory.

# Wildcards (*)
# Task: only list .txt files in your directory.



### Copy, rename and remove files

# Copy file
cp test2.txt test2_copy.txt

# Rename file
mv test2_copy.txt test2b.txt

# Remove file
rm test2b.txt

# Task: Exit Test_dir (move one level up) and delete directory.
# Task: Which options do you have to delete directories and why is one of them so dangerous?

# Create text file with ~5 lines of text on local computer and transfer file with scp to server
scp test_file.txt user@server:~/test_file.txt



### Permissions

# Clone repository (see git data roundtable: https://github.com/ZMT-Data-Roundtable/git-intro-r-roundtable)
git clone https://github.com/ZMT-Data-Roundtable/Linux-command-line-intro.git

# Task: Enter tutorial directory and list permissions

# give write permissions to the group
chmod g+w dummy.fasta

# Task: Give only yourself executable permission for the .sh file.



### Inspecting file contents and searching for patterns

# While for this tutorial, I am using examples from DNA sequencing, the commands work for any kind of text file/table

# View file contents
less dummy.fasta

# Task: View file content but cut lines at window edge.

# Count number of sequences, i.e. search for recurring pattern and count occurrences
grep -c '^>' dummy.fasta

# How many unique sequences (only containing ATCG) are there (translation: do not select lines which contain non-DNA characters)
grep -v '[^ACGT]' dummy.fasta | sort | uniq | wc -l

# Task: Why do we have to sort before the uniq?
# Task: Which other option are there to extract only the sequence lines from the file, and which option is fastest?

# Replace all minus with dots
sed 's/-/\./g' dummy.fasta > dummy2.fasta

# Task: What is the exact meaning of the sed command

# Save first 3 and last 3 accession numbers in a new file
grep '^>' dummy.fasta | head -3 | sed 's/^>//' > select.accnos
grep '^>' dummy.fasta | tail -3 | sed 's/^>//' >> select.accnos

# Task: Search for these accession numbers (and corresponding sequences) in original fasta file and save in new fasta file



### Line endings

# Linux: 
#   beginning of line: ^
#   end of line: $
#   new line: \n

# Windows:
#   end of line: ^M
#   new line: \r (carriage return)

# insepct file generated on Windows
less test_file.txt
cat -v test_file.txt
hexdump -c test_file.txt

# CAUTION: Make sure that you scripts and files are saved with line endings unix!

# Convert to line endings unix
dos2unix test_file.txt
less test_file.txt
cat -v test_file.txt
hexdump -c test_file.txt



### Modifying tables

# Create table with sequence accession number and sequence length
paste <(grep '^>' dummy.fasta | sed 's/^>//') <(grep -v '^>' dummy.fasta | perl -nle 'print length') > seq_lengths.txt

# Filter blast output
awk -v threshold=98 '($3 + $13) / 2 >= threshold' dummy.blastout > filtered.blastout

# Task: How many sequences were classified with these thresholds

# Only select the best match for each sequence
sort -k1,1 -k12,12gr -k11,11g filtered.blastout | sort -u -k1,1 --merge > best.blastout

# Only save selected columns in new file
cut -f1,2,3,13 best.blastout > dummy_blast_hits.txt

# Task: Add another column with the sequence length to dummy_blast_hits.txt
# Task: Which is the most abundant sequence in dummy.fasta?



### Checksums

# To ensure integrety of file after transfer, generate unique string for each file
md5sum *.fasta > md5_checksums.txt

# Check md5sums
md5sum -c md5_checksums.txt



### Variables and loops

# for demonstration purposes, duplicate fasta file
for i in $(seq 10 15)
do
  echo $i
  cp dummy.fasta "dummy"${i}".fasta"
done

# Task: Create list of sample names (dummy*) and use this to count the number of sequence per file (one file at a time)



### Resource monitoring

# How much disk space is available
df -h

# How large is the directory you are currently in
du -sh ./

# How many CPUs and how much RAM is currently being used
htop

# Disconnect during long running commands: use a screen

# Monitor progress of long running command: redirect output to logfile (command > test.log 2>&1)
tail -f test.log
# run outside of screen
# quit with ctrl + C

# Running commands in the background, e.g. compress blast output
gzip dummy.blastout &



### Questions?

# Google is your best friend :)
# ...and stackoverflow, etc.


