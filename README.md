# Image Query Reterival - IQR
```
                                  _____
                                  \_   \_ __ ___   __ _  __ _  ___
                                   / /\/ '_ ` _ \ / _` |/ _` |/ _ \
                                /\/ /_ | | | | | | (_| | (_| |  __/
                                \____/ |_| |_| |_|\__,_|\__, |\___|
                                                        |___/  Query Retrieval
```
                        
**Image Query Retrieval** is a tool that retrieves selected image information from a specific directory. It used for reporting and visualize your data lake.

## Requirements & Setup
```shell
#
# Install ImageMagick 
#
$ sudo apt-get install imagemagick

#
# Colne IQR repo
#
$ git clone https://github.com/amughrabi/iqr.git
$ cd iqr
Cloning into 'iqr'...

```
## Usage
It's really simple to use, just choose a directory from the lake and replace in the following command:
* EXPRESSION
* LOCATION
* OUTPUT
```shell
iqr.sh -e 'EXPRESSION' -l 'LOCATION' -o 'OUTPUT'
```
The EXPRESSION is the [Long/Short Form Attribute Percent Escapes](https://imagemagick.org/script/escape.php); for example, you can use `'%[basename],%[width]x%[height],%[colorspace],%[quality],%[size]'` to reterive the `name,WxH,COLORSPACE,QUALITY,SIZE` in your csv file.

The LOCATION is the directory that needs to be scanned.

The OUTPUT is the file log/csv/txt; etc. that need contains the output of the expression for each image.

#### Program options
```shell
$ iqr.sh -h
  _____
  \_   \_ __ ___   __ _  __ _  ___
   / /\/ '_ ` _ \ / _` |/ _` |/ _ \
/\/ /_ | | | | | | (_| | (_| |  __/
\____/ |_| |_| |_|\__,_|\__, |\___|
                        |___/  Query Retrieval

Usage:
iqr.sh [options] -e expression -l directory -o output.csv

    -h, -help,          --help                  Display help

    -v, -version,       --version               Display version

    -l, -location,      --location              Specify the root directory to start traversing the inode tree.

    -e, -expression,    --expression            Specify Attribute Percent Escapes (https://imagemagick.org/script/escape.php)
                                                to construct the expression for the output for each line; for example,
                                                '%[basename]:%[colorspace]\n' will log a line something like 'tjn.jpg:sRGB'

    -o, -output,        --output                Specify the output file; for example, output.csv.

    -V, -verbose,       --verbose               Run script in verbose mode. Will print out each step of execution.
```
## Examples
```shell
$ iqr.sh -e '%[basename],%[width]x%[height],%[colorspace],%[quality],%[size]' -l /home/amughrabi/drive/ -o /home/amughrabi/personal/drive.csv
  _____
  \_   \_ __ ___   __ _  __ _  ___
   / /\/ '_ ` _ \ / _` |/ _` |/ _ \
/\/ /_ | | | | | | (_| | (_| |  __/
\____/ |_| |_| |_|\__,_|\__, |\___|
                        |___/  Query Retrieval

Scan                    : /home/amughrabi/drive/
Output                  : /home/amughrabi/personal/drive.csv
To See the results; Use : tail -f /home/amughrabi/personal/drive.csv

Done: /home/amughrabi/personal/tandf.csv

If you like it, please * this project on GitHub to make it known:
  https://github.com/amughrabi/iqr

Bye!!

```
If you have a large lake space and you need to see the progress, you can see the progress by using `tail -f /home/amughrabi/personal/drive.csv` in a new terminal.

After the process is completed, use some visual tools such as Excel to understand what is going on in your lake.

You can also scan 1 image - Please note that if the `-o` is not added to the command, the output of the expression will be on the console.
```shell
b$ iqr.sh -e '%[basename],%[width]x%[height],%[colorspace],%[quality],%[size]' -l ~/mughrabi.jpg 
  _____
  \_   \_ __ ___   __ _  __ _  ___
   / /\/ '_ ` _ \ / _` |/ _` |/ _ \
/\/ /_ | | | | | | (_| | (_| |  __/
\____/ |_| |_| |_|\__,_|\__, |\___|
                        |___/  Query Retrieval

Scan                    : /home/amughrabi/mughrabi.jpg

Output:
mughrabi,117x150,sRGB,92,30.9KB


Done: 

If you like it, please * this project on GitHub to make it known:
  https://github.com/amughrabi/iqr

Bye!!

```
## Testing
Passed - We tested it on 37502 images (Dataset details: https://www.kaggle.com/c/dogs-vs-cats). Make sure you have enough space to generate the output file.

## Thanks!!
For any kind of problem, please don't hesitate to open an issue here on *GitHub*.

*Ahmad Al Mughrabi*
