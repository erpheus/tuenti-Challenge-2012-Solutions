# Challenge 8: The demented cloning machine 
# Author: José Antonio Porras

require "digest/md5"

@tr = []
@m = Digest::MD5.new
ARGF.each_with_index{|l,i|
  @str = l.strip if i==0
  @tr << Hash[l.strip.split(",").each.map{|e| e.split("=>")}] if i>0 && l.strip.length>0}

@tr.reverse!
@tr.each_with_index{|d,i|
    @tr[i+1] = (Hash[@tr[i+1].each.map{|k,v| [k,v.each_char.collect{|car| @tr[i][car].nil? ? car : @tr[i][car]}.join]}]).merge(@tr[i]){|key,v1,v2| v1} if i<@tr.length-1 }

r = Regexp.new("[#{@tr[@tr.length-1].keys.join}]")
@str.each_char{|c| @m  << c.gsub(r,@tr.last) }
puts @m.hexdigest