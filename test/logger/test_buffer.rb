# coding: US-ASCII
# frozen_string_literal: false
require_relative '../helper'
require 'logger'

class TestBuffer < Test::Unit::TestCase
  def test_block_argument
    r, w = IO.pipe
    logger = Logger.new(w)
    
    logger.info do |buffer|
      buffer.puts "Hello"
      buffer.puts "World"
    end
    
    IO.select([r], nil, nil, 0.1)
    w.close
    msg = r.read
    r.close
    
    assert_include msg, "Hello"
    assert_include msg, "World"
  end
end
