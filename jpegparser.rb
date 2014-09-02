# copyright (c) 2014 guardiancrow

class JPEGParser
  def initialize(filename)
    @valid = false
    @comment = false
    @app0 = false
    @app1 = false
    @appx = false
    @force = false
    p "#{filename} filesize : %d bytes"%[File.size(filename)]
    File.open(filename, 'rb') do |io|
      validate(io)
    end
    p "Vaild OK"
  end

  class << self

  attr_reader :valid #[boolean] test results of the JPEG file
  attr_reader :comment #[boolean] have comments?
  attr_reader :app0 #[boolean] have JFIF?
  attr_reader :app1 #[boolean] have Exif?
  attr_reader :appx #[boolean] have metadata? not JFIF and Exif
  attr_reader :force #[boolean] forced output

  def writecorejpeg(infilename, outfilename)
    p "[input] #{infilename} filesize : %d bytes"%[File.size(infilename)]
    File.open(infilename, 'rb') do |io|
      validate(io)
    end

    unless @valid then
      p "#{infilename} Valid NG"
      return
    end
    #p "#{infilename} Valid OK"

    unless @comment or @app1 or @appx then
      if @force then
        File.binwrite(outfilename, File.binread(infilename))
      else
        p "no need to output"
      end
      return
    end

    insize = File.size(infilename)

    File.open(infilename, 'rb') do |iio|
      File.open(outfilename, 'wb') do |oio|
        oio.write(iio.read(2))

        while iio.read(1).unpack("C") == [0xff]
          marker = iio.read(1).unpack("C")
          case marker[0]
          when 0xff
            redo
          when 0xe1..0xef, 0xfe
            framesize = iio.read(2).unpack("n1")
            iio.seek(framesize[0]-2, IO::SEEK_CUR)
            redo
          when 0xda #SOS
            oio.write([0xff].pack("C"))
            oio.write(marker.pack("C"))
            current = iio.tell
            oio.write(iio.read(insize - current))
            break
          else
            oio.write([0xff].pack("C"))
            oio.write(marker.pack("C"))
            framesize = iio.read(2).unpack("n1")
            oio.write(framesize.pack("n1"))
            oio.write(iio.read(framesize[0]-2))
          end
        end
      end
    end
    p "[output] #{outfilename} filesize : %d bytes"%[File.size(outfilename)]
  end

  private
  def validate(io)
    #p 'Start validation...'
    @valid = false
    @comment = false
    @app0 = false
    @app1 = false
    @appx = false

    # checking SOI
    unless io.read(2).unpack("C2") == [0xff, 0xd8]
      #raise StandardError, "no JPEG file"
      return false
    end

    io.seek(-2, IO::SEEK_END)
    # checking EOI
    unless io.read(2).unpack("C2") == [0xff, 0xd9]
      #raise StandardError, "no JPEG file"
      return false
    end

    # parsing Marker
    io.seek(2, IO::SEEK_SET)
    while io.read(1).unpack("C") == [0xff]
      marker = io.read(1).unpack("C")
      #p "marker :: %#x"%[marker[0]]
      case marker[0]
      when 0xd9, 0xda
        #p "scan end"
        break
      when 0xfe
        @comment = true
      when 0xe0
        @app0 = true
      when 0xe1
        @app1 = true
      when 0xe2..0xef
        @appx = true
      else
      end
      framesize = io.read(2).unpack("n1")
      # p "framesize :: %d bytes"%[framesize[0]]
      io.seek(framesize[0] - 2, IO::SEEK_CUR)
    end
    #p 'Finish validation...'
    @valid = true
    return true
  end

  end # class << self
end


