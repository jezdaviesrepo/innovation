import os, time, urllib.request, urllib.parse
import xml.etree.ElementTree as ET

QUERY = 'all:"text to sql" OR all:nl2sql'
SINCE = "2024-01-01"
NS = {"a": "http://www.w3.org/2005/Atom"}
links, start, done = [], 0, False

while not done:
    url = "https://export.arxiv.org/api/query?" + urllib.parse.urlencode({
        "search_query": QUERY, "start": start, "max_results": 100,
        "sortBy": "submittedDate", "sortOrder": "descending"})
    root = ET.fromstring(urllib.request.urlopen(url).read())
    entries = root.findall("a:entry", NS)
    if not entries:
        break
    for e in entries:
        if e.find("a:published", NS).text[:10] < SINCE:
            done = True
            break
        pid = e.find("a:id", NS).text.split("/abs/")[-1]
        links.append(f"https://arxiv.org/pdf/{pid}")
    start += 100
    time.sleep(3)

open("links.txt", "w").write("\n".join(links))
print(len(links), "papers found")

os.makedirs("papers", exist_ok=True)
for link in links:
    name = link.split("/")[-1] + ".pdf"
    urllib.request.urlretrieve(link, os.path.join("papers", name))
    time.sleep(3)
