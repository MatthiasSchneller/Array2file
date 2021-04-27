# Array2file

This is a simple script that will save a given Matrix or Vector onto a file,
and reads it back in again.

## Installation
First clone the repository
```
/your/path$ git init
/your/path$ git clone https://github.com/MatthiasSchneller/Array2file.git
```

Now start Julia, and change to the package environment by typing ']'.
Install the package using:

```
pkg> add Array2file/
```

## Usage

There are two functions that can be called in this package. You can either
write in a file, or you can read from it.

### Write functions

Because in a text file you write row by row, but Julia
writes column by column, in the resulting text file the
columns of the Julia array will be saved in the rows
of the text file.

    writefile(A::Vector{\<:Number}, str::String)

The vector `A` will be saved in a file denoted by `str`.
    
    writefile(A::Matrix{\<:Number}, str::String)

The matrix `A` will be saved in a file denoted by `str`.

#### Example
```
julia\> A = [1, 2, 3, 4]
4-element Array{Int64,1}:
 1
 2
 3
 4
julia\>writefile(A, "test.txt")
shell\> cat test.txt
1	2	3	4
julia> A = reshape(A, 2, 2)
2×2 Array{Int64,2}:
 1  3
 2  4
julia\> writefile(A, "test.txt")
shell\> cat test.txt
1	2
3	4
```

### Read function

The read function will read in the data that was saved in a given file,
and parse it to a wanted data type.

    readfile(str::String, dtype::DataType)

Read in the Matrix or Vector from the file given by `str`, and parse
it to the data type given by `dtype`.

#### Example
```
shell\> cat "test.txt"
1	2
3	4
julia\> readfile("test.txt", Int)
2×2 Array{Int64,2}:
1  3
2  4
``` 
