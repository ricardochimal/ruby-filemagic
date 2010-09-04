require "test/unit"
require "filemagic"

class TestFileMagic < Test::Unit::TestCase
  def setup
    @oldwd = Dir.getwd
    Dir.chdir( File.dirname(__FILE__) )
  end

  def teardown
    Dir.chdir( @oldwd )
  end

  def test_file
    fm = FileMagic.new(FileMagic::MAGIC_NONE)
    res = fm.file("pyfile")
    assert_equal("a python script text executable", res)
    res = fm.file("pylink")
    assert_equal("symbolic link to `pyfile'", res)
    fm.close
    fm = FileMagic.new(FileMagic::MAGIC_SYMLINK)
    res = fm.file("pylink")
    assert_equal("a python script text executable", res)
    fm.close
    fm = FileMagic.new(FileMagic::MAGIC_SYMLINK | FileMagic::MAGIC_MIME)
    res = fm.file("pylink")
    assert_equal("text/plain; charset=us-ascii", res)
    fm.close
    fm = FileMagic.new(FileMagic::MAGIC_COMPRESS)
    res = fm.file("pyfile-compressed.gz")
    assert_equal('a python script text executable (gzip compressed data, was "pyfile-compressed", from Unix, last modified: Wed Jul 30 21:20:45 2003)', res)
    fm.close
  end

  def test_buffer
    fm = FileMagic.new(FileMagic::MAGIC_NONE)
    res = fm.buffer("#!/bin/sh\n")
    fm.close
    assert_equal("POSIX shell script text executable", res)
  end

  def test_check
    fm = FileMagic.new(FileMagic::MAGIC_NONE)
    res = fm.check("perl")
    fm.close
    assert_equal(res, 0)
  end

  def test_compile
    fm = FileMagic.new(FileMagic::MAGIC_NONE)
    res = fm.compile("perl")
    fm.close
    assert_equal(res, 0)
    File.unlink("perl.mgc")
  end

  def test_new
    assert_raise(ArgumentError) do
      FileMagic.new(FileMagic::MAGIC_COMPRESS, nil)
    end
    assert_nothing_raised do
      fm = FileMagic.new
      assert_equal(FileMagic::MAGIC_NONE, fm.flags)
    end
  end

  def test_flags
    fm = FileMagic.new(FileMagic::MAGIC_COMPRESS)
    assert_equal(FileMagic::MAGIC_COMPRESS, fm.flags)
    fm.flags = FileMagic::MAGIC_NONE
    assert_equal(FileMagic::MAGIC_NONE, fm.flags)
  end
end
