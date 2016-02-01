class String
    def count(needle, skip = true)
        pos = -1
        counter = 0
        while(pos = self.index(needle, pos + (skip ? needle.length : 1)))
            counter += 1
        end
        counter
    end
end

keywords = Array.new
keywords.push "\u540C\u6027\u6200"  # 同性戀
keywords.push "\u540C\u5FD7"        # 同志
#keywords.push "\u73BB\u7483\u5708"  # 玻璃圈
keywords.push "\u9177\u5152"        # 酷兒
keywords.push "\u65B7\u80CC"        # 斷背

pwd = Dir.pwd
require "fileutils"

keywords.each do |keyword|
    Dir.chdir pwd
    Dir.chdir keyword
    puts keyword
    Dir.foreach(".") do |year|
        if(year == "." || year == "..") then next end
        puts year
        if(Dir.entries(year).size == 2) then
            puts "No data in " + year
            next
        end
        $hash = Hash.new
        $hash.default = 0
        $log = File.open("log" + year + ".csv", "a")
        Dir.foreach(year) do |news|
            if(news == "." || news == "..") then next end
            
            File.open(year + "/" + news) do |file|
                $count = file.read.encode("UTF-8", "UTF-8").count(keyword)
            end
            
            parts = news.split("_")
            $log.write parts[0] + "," + $count.to_s + "," + parts[1] + "\n"
            $hash[parts[0]] += $count
            
            parts[2] = $count.to_s            
            newName = parts.join("_") + ".txt"
            if(news != newName) then
                puts "moved to " + newName
                FileUtils.move (year + "/" + news), (year + "/" + newName)
            end       
        end
        $log.close
        File.open("statistics" + year + ".csv", "a") do |stat|            
            $hash.each do |date, count|
                stat.write date + "," + count.to_s + "\n"
            end
        end
    end
end