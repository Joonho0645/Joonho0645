# file open emails.csv
# make regex of email
# make hash of emails
# .each line scan file for matching regex
# conditional if email exists add 1 count
# if doesnt exist start count at 1
# sort hash by descending order of highest count
def scan_for_emails(file)
  regex = /[\w\.\_\-]+@\w+\.\w+/
  email_hash = {}
  File.open(file, "r").each_line do |line|
    line.downcase.scan(regex).each do |email|
      if email_hash.key?(email)
        email_hash[email] += 1
      else
        email_hash[email] = 1
      end
    end
  end
  email_hash
end

def desc_freq_emails(file, number_of_emails)
  scan_for_emails(file).sort_by{ |key, value| -value }[0..number_of_emails - 1]
end

puts desc_freq_emails('./Emails.csv', 20)
