# * Read from file

file_location = "./demo_files/sample.txt"
new_content = "I'm new content!"

# Method 1
file = File.open(file_location)
content = file.read

# Method 2
file_content = File.read(file_location)

# * Writing to file

# Method 1
File.write(file_location, new_content, mode: "a") # Symbol argument mode: "a" tells method to append instead of overwrite (default)

# Method 2
File.open(file_location, "a") do |file|
    file.write(new_content)
end

# * Reading CSV

require "csv"
csv_location = "./demo_files/sample.csv"

# Method 1 - Treat as string
csv_string = File.read(csv_location) # This isn't very useful, can't access data easily.

# Method 2 - CSV library
csv_file = File.read(csv_location)
csv_data = CSV.parse(csv_file, headers: true)
# headers: true arg allows us to access each attr as apart of a hash, referencing the header as the key
# Without it, we get array of arrays for lines. As stated, this returns an array of hases.

csv_data.each do |d|
    puts "Date: #{d["date"]} Price: #{d["price"]}"
end

# Method 3 - Clean it up
csv_parsed = CSV.read(csv_location, headers: true, col_sep: ",") # col_sep specifies CSV delimiter/seperator

# * Writing CSV

data = [
    ["id", "first_name", "last_name"],
    [1, "Johh", "Doe"],
    [2, "Michael", "Smith"],
    [3, "Sally", "Dean"],
    [4, "Peter", "Rabbit"],
    [5, "Jessie", "Fanning"]
] # CSV formatted array of arrays, what simple CSV.parse returns

# Method 1 - Write as string
csv_string = data.map{ |d| d.join(",") }.join("\n")
File.write("./demo_files/demo_generated.csv", csv_string)

# Method 2 - CSV library
CSV.open("./demo_files/demo_generated.csv", "w") do |c| # You guessed it! "w" means write, use "a" to append
    # c is CSV array of arrays, << operator is to append
    c << ["id", "first_name", "last_name"]
    c << [1, "Johh", "Doe"]
    c << [2, "Michael", "Smith"]
    c << [3, "Sally", "Dean"]
    c << [4, "Peter", "Rabbit"]
    c <<  [5, "Jordyn", "Mindorff"]
end

# Method 3 - Slightly different, use CSV library to generate CSV string and then write to file
generated_csv = CSV.generate do |c|
    c << ["id", "first_name", "last_name"]
    c << [1, "Johh", "Doe"]
    c << [2, "Michael", "Smith"]
    c << [3, "Sally", "Dean"]
    c << [4, "Peter", "Rabbit"]
    c <<  [5, "Jordyn", "Murphy Mindorff"]
end

File.write("./demo_files/demo_generated.csv", generated_csv)

# * Reading JSON

require 'json'

json_string = '{ "id": 1, "firstName": "Lead", "lastName": "Organa"}' # Could also read/load JSON as if it was a text file here
json_data = JSON.parse(json_string) # Parses JSON string into hash, JSON.load also exists, which can also accept a direct file reference
puts json_data['id']

# * Generate JSON

# Method 1
hash = {
    id: 1,
    firstName: "Leah",
    lastName: "Organa"
}

hash_json = hash.to_json # Converts into JSON String
re_hash = JSON.parse(hash_json) # Converts back into hash if you wanted to

# Then use your JSON! Could even just write it to a whatever.json file as if it were a regular txt file. 

# Method 2 - Different function, can take more complex arguments, but still returns JSON string
hash_json_2 = JSON.dump(hash)
# Method 3 - Returns formatted/prettified JSON string with newlines, indents, etc.
hash_json_3 = JSON.pretty_generate(hash)
puts hash_json_3

# * Making a GET Request

require 'net/http'


# Method 1
endpoint = "https://jsonplaceholder.typicode.com/todos/1"

uri = URI(endpoint) # Parse string into URI object
response_content = Net::HTTP.get(uri) # Returns JSON/Response Body String

puts response_content

# Method 2
response = Net::HTTP.get_response(uri) # Returns Full Response Object

puts response.code
puts response.content_type
puts response.body