# copyright (c) 2014 guardiancrow

require 'securerandom'
require './jpegparser.rb'

#ganerate output file name
outfilename = "#{ARGV[0]}"
outfilename = outfilename.gsub(/\.jpg/i, "")
outfilename = outfilename.gsub(/\.jpeg/i, "")
outfilename = "%s_%s.jpg"%[outfilename, SecureRandom.hex(5)]

#do it
JPEGParser.writecorejpeg("#{ARGV[0]}", outfilename)

#output result
p "File Validation : %s"%[JPEGParser.valid ? 'OK' : 'NG']
p "Have Comments? : %s"%[JPEGParser.comment ? 'YES' : 'NO']
p "Have JFIF? : %s"%[JPEGParser.app0 ? 'YES' : 'NO']
p "Have Exif? : %s"%[JPEGParser.app1 ? 'YES' : 'NO']
p "Have APPx? : %s"%[JPEGParser.appx ? 'YES' : 'NO']
