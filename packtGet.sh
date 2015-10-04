#!/bin/bash
# By José González

# API description
# * Base URL:
# 	* https://www.packtpub.com

# * Claim:
# 	* Referer:
# 		* https://www.packtpub.com/packt/offers/free-learning
# 	* /freelearning-claim/{bookID}/{freeEbookId}

# * Download:
# 	* Referer:
# 		* https://www.packtpub.com/account/my-ebooks
# 	* /ebook_download/{bookID}/pdf
# 	* /ebook_download/{bookID}/epub
# 	* /ebook_download/{bookID}/mobi


cookie=‘SESS_live=abcd1234;'

baseUrl="https://www.packtpub.com/"
bookInfoEP="packt/offers/free-learning"

echo "[+] Get response"
# response=`curl --silent --cookie "${cookie}" --data "${ua}" "${baseUrl}${bookInfoEP}"`
bookUrl=`curl -k --silent "${baseUrl}${bookInfoEP}" |grep twelve-days-claim |cut -d'"' -f2`
bookTitle=`curl -k --silent "${baseUrl}${bookInfoEP}" |grep h2 |awk -F"<h2>" '{print $1}' |sed 's|</h2>||g' |sed 's/[[:space:]]//g'`
bookID=`echo ${bookUrl} |cut -d"/" -f3`
bookDownloadEP="ebook_download/${bookID}"
echo "[+] Book url is: ${bookUrl}"
echo "[+] Title is: ${bookTitle:1}:${bookID}"

# Claim book
echo "[+] Claiming book"
curl -k --silent --cookie "${cookie}" "${baseUrl}${bookUrl}"

echo "[+] Downloading book"
# Download book
curl -k --silent --cookie "${cookie}" --output "./packtBooks/${bookTitle:1}.pdf" "${baseUrl}${bookDownloadEP}/pdf"

echo "[+] Done”
