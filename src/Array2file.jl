module Array2file

export writefile, readfile

"""
    writefile(A::Matrix{<:Number}, str::String)

Write a matrix on disc.

This function will write the matrix A in the file located in str.
Be aware that the file will write the colums of the matrix in the
rows of the data file, and the other way around. This is due to the
column majorness of julia, but the row majorness of a text file.

# Example
```jldoctest
julia> A = reshape([1, 2, 3, 4], 2, 2)
2×2 Array{Int64,2}:
 1  3
 2  4

julia> writefile(A, "test.txt")

shell> cat test.txt
1	2	
3	4
```

See also: [`readfile`](@ref)
"""
function writefile(A::Matrix{<:Number}, str::String)
    # A     ...   the array that will be saved on disc
    # str   ...   the location of the text file
    
    # open the output stream
    open(str, "w") do io

        # iterate over the elements of the matrix
        for i=1:size(A, 2)
            for j=1:size(A, 1)

                # write the corresponding element on the file
                # and seperate the value with an tabulator
                write(io, string(A[j, i])*"\t")
            end

            #after each written column write a newline
            write(io, "\n")
        end

    # close the io stream
    end

    # return nothing
    return
end


"""
    writefile(A::Vector{<:Number}, str::String)

Write a vector to a file.

This function will write the Vector A to the file
located at str.

# Example
```jldoctest
julia> writefile([1, 2, 3, 4], "test.txt")

shell> cat test.txt
1	2	3	4
```

See also: [`readfile`](@ref)
"""
function writefile(A::Vector{<:Number}, str::String)
    # A     ...   the vector that will be saved on disc
    # str   ...   the location of the text file

    # open the output stream
    open(str, "w") do io

        # iterate over the elements of the vector
        for i=1:size(A, 1)

            # write the elements on the file, add separator
            write(io, string(A[i])*"\t")
        end

        # signal the end of the file
        write(io, "\n")

    # close the file stream
    end

    # return nothing
    return
end


"""
    readfile(str::String, dtype::DataType)

Read in a matrix.

This function reads in a vector or a matrix that is save at the str 
position. The input will be parsed into the DataType that is given
in the dtype variable.

# Example
```jldoctest
shell> cat test.txt
1	2	
3	4	

julia> readfile("test.txt", Int)
2×2 Array{Int64,2}:
 1  3
 2  4
```

See also: [`writefile`](@ref)
"""
function readfile(str::String, dtype::DataType)
    # str     ...   the location of the file that contains the matrix
    # dtype   ...   the datatype that will be parsed
    
    # load the data into the input string
    input = open(f->read(f, String), str)

    # set the starting index
    index_start = 1

    # start the row counter
    rows = 0

    # create the starting Array
    output = Array{dtype}(undef, 0)

    # create the endless loop that evaluates the input stream data
    while true

        # read out the position of the next tabulator or newline command
        index_tab = findnext(isequal('\t'), input, index_start)
        index_nl  = findnext(isequal('\n'), input, index_start)

        # if the matrix is already read in, break the loop
        if index_tab == nothing
            rows += 1
            break

        # if the next seperator is a tab, parse the chars to this point,
        # and fill the output array with it. Set a new index_start
        elseif index_tab < index_nl
            index_end = index_tab
            append!(output, parse(dtype, input[index_start:index_end-1]))
            index_start = index_end + 1

        # if the next seperator is a newline, increase the row counter,
        # and set the new start index
        else
            rows += 1
            index_start += 1
        end
    end

    # reshape the array to the wanted outputsize
    output = reshape(output, round(Int, length(output)/rows), rows)

    return output
end

# end module
end
