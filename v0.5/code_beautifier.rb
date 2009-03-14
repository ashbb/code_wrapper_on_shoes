#!/usr/bin/ruby -w

=begin
/***************************************************************************
 *   Copyright (C) 2008, Paul Lutus                                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
=end

PVERSION = "Version 2.4, 08/25/2008"

module RBeautify

   # tab character and size

   TabStr = " "
   TabSize = 2    # changed 3 --> 2 by satoshi 2008.9.6

   # indent regexp tests

   IndentExp = [
      /^module\b/,
      /^class\b/,
      /^if\b/,
      /(=\s*|^)until\b/,
      /(=\s*|^)for\b/,
      /^unless\b/,
      /(=\s*|^)while\b/,
      /(=\s*|^)begin\b/,
      /(^| )case\b/,
      /\bthen\b/,
      /^rescue\b/,
      /^def\b/,
      /\bdo\b/,
      /^else\b/,
      /^elsif\b/,
      /^ensure\b/,
      /\bwhen\b/,
      /\{[^\}]*$/,
      /\[[^\]]*$/
   ]

   # outdent regexp tests

   OutdentExp = [
      /^rescue\b/,
      /^ensure\b/,
      /^elsif\b/,
      /^end\b/,
      /^else\b/,
      /\bwhen\b/,
      /^[^\{]*\}/,
      /^[^\[]*\]/
   ]

   def RBeautify.rb_make_tab(tab)
      return (tab < 0) ? "" : TabStr * TabSize * tab
   end

   def RBeautify.rb_add_line(line,tab)
      line.strip!
      line = rb_make_tab(tab) + line if line.length > 0
      return line + "\n"
   end

   def RBeautify.beautify_string(source, path = "")
      comment_block = false
      program_end = false
      multiLine_array = []
      multiLine_str = ""
      tab = 0
      dest = ""
      source.split("\n").each do |line|
         if(!program_end)
            # detect program end mark
            if(line =~ /^__END__$/)
               program_end = true
            else
               # combine continuing lines
               if(!(line =~ /^\s*#/) && line =~ /[^\\]\\\s*$/)
                  multiLine_array.push line
                  multiLine_str += line.sub(/^(.*)\\\s*$/,"\\1")
                  next
               end

               # add final line
               if(multiLine_str.length > 0)
                  multiLine_array.push line
                  multiLine_str += line.sub(/^(.*)\\\s*$/,"\\1")
               end

               tline = ((multiLine_str.length > 0)?multiLine_str:line).strip
               if(tline =~ /^=begin/)
                  comment_block = true
               end
            end
         end
         if(comment_block || program_end)
            # add the line unchanged
            dest += line + "\n"
         else
            comment_line = (tline =~ /^#/)
            if(!comment_line)
               # throw out sequences that will
               # only sow confusion
               while tline.gsub!(/\{[^\{]*?\}/,"")
               end
               while tline.gsub!(/\[[^\[]*?\]/,"")
               end
               while tline.gsub!(/'.*?'/,"")
               end
               while tline.gsub!(/".*?"/,"")
               end
               while tline.gsub!(/\`.*?\`/,"")
               end
               while tline.gsub!(/\([^\(]*?\)/,"")
               end
               while tline.gsub!(/\/.*?\//,"")
               end
               while tline.gsub!(/%r(.).*?\1/,"")
               end
               # delete end-of-line comments
               tline.sub!(/#[^\"]+$/,"")
               # convert quotes
               tline.gsub!(/\\\"/,"'")
               OutdentExp.each do |re|
                  if(tline =~ re)
                     tab -= 1
                     break
                  end
               end
            end
            if (multiLine_array.length > 0)
               multiLine_array.each do |ml|
                  dest += add_line(ml,tab)
               end
               multiLine_array.clear
               multiLine_str = ""
            else
               dest += rb_add_line(line,tab)
            end
            if(!comment_line)
               IndentExp.each do |re|
                  if(tline =~ re && !(tline =~ /\s+end\s*$/))
                     tab += 1
                     break
                  end
               end
            end
         end
         if(tline =~ /^=end/)
            comment_block = false
         end
      end
      if(tab != 0)
         STDERR.puts "#{path}: Indentation error: #{tab}"
      end
      return dest
   end # beautify_string

   def RBeautify.beautify_file(path)
      if(path == '-') # stdin source
         source = STDIN.read
         print beautify_string(source,"stdin")
      else # named file source
         source = File.read(path)
         dest = beautify_string(source,path)
         if(source != dest)
            # make a backup copy
            File.open(path + "~","w") { |f| f.write(source) }
            # overwrite the original
            File.open(path,"w") { |f| f.write(dest) }
         end
      end
   end # beautify_file

   def RBeautify.main
      if(!ARGV[0])
         STDERR.puts "usage: Ruby filenames or \"-\" for stdin."
         exit 0
      end
      ARGV.each do |path|
         RBeautify.beautify_file(path)
      end
   end # main
end # module RBeautify

# if launched as a standalone program, not loaded as a module
if __FILE__ == $0
   RBeautify.main
end
