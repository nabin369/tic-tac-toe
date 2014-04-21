#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib',__FILE__)

require 'ttt'

ttt = TTT.new
ttt.play_game

