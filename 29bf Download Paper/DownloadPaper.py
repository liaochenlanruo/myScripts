import os
import argparse
import random

parser = argparse.ArgumentParser(description='argparse testing')
parser.add_argument('--infile','-f',type=str, default = "paper.csv",required=True,help="the paper list in a file")
parser.add_argument('--out','-o',type=str, default='Papers',help='the output directory')
parser.add_argument('--ifc','-c',type=int, default='10',help='the impact factor cutoff')

args = parser.parse_args()

def checkDir(Dir):
	Dir=os.path.abspath(Dir)
	if not os.path.exists(Dir):
		os.makedirs(Dir)


desktop_agents = [
	"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0",
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299",
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36 OPR/52.0.2871.64",
]

mobile_agents = [
	"Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
	"Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
	"Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36",
	"Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36",
]

def generate_user_agent():
	agents = desktop_agents + mobile_agents
	return random.choice(agents)

user_agent = generate_user_agent()
print(user_agent)


def download_doi(path,prefix,doi):
	import requests
	from bs4 import BeautifulSoup
	head = {
		'user-agent': "user_agent"
	}
	#head = {
	#	'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36'}
	url = "https://www.sci-hub.ren/" + doi + "#"
	try:
		download_url = ""
		r = requests.get(url, headers=head)
		r.raise_for_status()
		r.encoding = r.apparent_encoding
		soup = BeautifulSoup(r.text, "html.parser")
		if soup.iframe == None:
			download_url = "https:" + soup.embed.attrs["src"]
		else:
			download_url = soup.iframe.attrs["src"]
		print(prefix+"\t"+ doi + "\tDownloading\nThe link is\t" + download_url)
		download_r = requests.get(download_url, headers=head)
		download_r.raise_for_status()
		with open(path + "/" + prefix + ".pdf", "wb+") as temp:
			temp.write(download_r.content)
	except:
		with open("error.log", "a+") as error:
			error.write(prefix + "\tDownload failed!\n")
			if "https://" in download_url:
				error.write(" The download URL is: " + download_url + "\n\n")
	else:
		download_url = ""
		print(prefix + "\tDownload successful.\n")

def read_AIweb_downloaded_xls(path,infile,IF_cutoff=args.ifc):

	import xlrd
	import datetime
	workbook = xlrd.open_workbook(infile)
	worksheet = workbook.sheet_by_index(0)
	nrows = worksheet.nrows
	print(path)
	for i in range(1, nrows):
		try:
			title = str(worksheet.cell_value(i, 0))
			title.replace(" ","_")

			journal=str(worksheet.cell_value(i, 1))
			journal.replace(" ","_")

			IF = str(worksheet.cell_value(i, 2))

			date=str(worksheet.cell_value(i, 5))
			date_tuple = xlrd.xldate_as_tuple(float(date), 0)
			dt = datetime.datetime(*date_tuple[0:3])
			formatted_date=dt.strftime('%Y-%m-%d')

			prefix=f'{formatted_date}-{journal}-{IF}-{title}'

			doi= str(worksheet.cell_value(i, 3))

			if float(IF)<IF_cutoff:
				print(prefix+"\t"+doi+"\tThe IF is lower than the cutoff "+str(IF_cutoff))
				continue
			download_doi(path, prefix, doi)

		except Exception as e:
			print(e)
			print("line " + str(i) + "not exist")
			continue

def read_AIweb_downloaded_csv(path,infile,IF_cutoff=args.ifc):
	import csv
	import datetime

	with open(infile, 'r',encoding='utf-8') as file:
		reader = csv.reader(file)
		for row in reader:
			if "PMID" in row:
				continue
			try:
				title = str(row[0])
				title.replace(" ","_")

				journal=str(row[1])
				journal.replace(" ","_")

				IF = str(row[2])

				date=str(row[5])

				prefix=f'{date}-{journal}-{IF}-{title}'

				doi= str(row[3])

				if float(IF)<IF_cutoff:
					print(prefix+"\t"+doi+"\tThe IF is lower than the cutoff "+str(IF_cutoff))
					continue
				else:
					print(prefix + "\t" + doi + "\tThe IF is higher than the cutoff " + str(IF_cutoff))
					download_doi(path, prefix, doi)

			except Exception as e:
				print(e)
				continue

if __name__ == '__main__':
	path=args.out
	checkDir(path)
	infile=args.infile
	#IFcutoff=args.ifc
	read_AIweb_downloaded_csv(path,infile,IF_cutoff=args.ifc)
	#read_AIweb_downloaded_xls(path, infile, IF_cutoff=IFcutoff) # 如人工进行了Excel中的筛选导出的是xls文件，可以使用该函数下载
