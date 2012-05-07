# Challenge 9: Il nomme della magnolia
# Author: José Antonio Porras

@doc = Array.new(5)
800.times{|c|
  filename = "%04d" % (c+1) 
  f = File.open("#{File.dirname(__FILE__)}/documents/#{filename}")
  @doc[c] = f.sysread(f.size) 
}

def find_document(word,n)
  enc = false
  i=0
  oc=0
  offset=0
  r=Regexp.new("\\b#{word}\\b",true)
  while !enc && (i < (@doc.length-1))
    offset = @doc[i].scan(r).length
    oc += offset
    enc=true if oc>=n
    i+=1
  end
  (i==@doc.length) ? nil : [(i-1), oc-offset]              
end

def find_line(doc,word,n,oc_old)
  r = Regexp.new("\\b#{word}\\b",true)
  count = oc_old
  count_line = 0
  oc = []
  @doc[doc].each_line{|line|
    if line.scan(r).length>0 
      count_word = 0
      line.strip.split(" ").each_with_index{|x,i| 
        if x.match(r)
          oc << [count_line,i]
        end
      }
    end
    count_line +=1
  }
  oc[n-oc_old-1]
end  

def find_all(word,n)
  d,o = find_document(word,n)
  l = find_line(d,word,n,o)
  "#{d+1}-#{l[0]+1}-#{l[1]+1}"
end

ARGF.each_with_index{|d,i|
  puts find_all(d.strip.split(" ")[0],d.strip.split(" ")[1].to_i) if i>0
}