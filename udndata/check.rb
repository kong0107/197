keywords = Array.new
keywords.push "\u540C\u6027\u6200"  # 同性戀
keywords.push "\u540C\u5FD7"        # 同志
keywords.push "\u73BB\u7483\u5708"  # 玻璃圈
keywords.push "\u9177\u5152"        # 酷兒
keywords.push "\u65B7\u80CC"        # 斷背

pwd = Dir.pwd

keywords.each do |keyword|
    File.open(keyword + ".csv") do |csv|
        csv.read.split("\n").each do |line|
            pair = line.split ","
            year = pair[0]
            count = pair[1].to_i
            fileCount = Dir.entries(keyword + "/" + year).size - 2
            if(fileCount != count) then
                puts keyword + line + ",\t" + fileCount.to_s
            end
        end
    end
end


#同性戀1998,417, 333
#同性戀1999,320, 276
#同志1998,727,   509
#同志1999,701,   478
#同志2002,686,   685