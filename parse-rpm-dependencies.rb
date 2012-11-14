#!/usr/bin/ruby

# extract tree from repoquery
lines=`repoquery -a --installed --resolve --tree-whatrequires --quiet`.split(/\n/)
nodes={}
nodecounts={}

# build base nodes
lastnode=nil
lines.each do |line|
  if line =~ /^([^ ].*?) /
    lastnode=$1
    if lastnode =~ /.*:(.*)/
      lastnode=$1
    end
    nodes[lastnode]=[]
  end

  if line =~ / \\_  ([^ ]+)/
    nodes[lastnode].push $1
  end
end

# count node dependencies
nodes.keys.each do |key|
  len=nodes[key].length
  unless nodecounts.has_key? len
    nodecounts[len]=[]
  end
  nodecounts[len] << key
end

# sort nodecounts ascending to print node and how many total dependencies it has
nodecounts.keys.sort.each do |count|
  puts "#{count}\t#{nodecounts[count].sort.join("\n\t")}"
end
