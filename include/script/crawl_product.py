import random
import time
import urllib
import pymongo
from bs4 import BeautifulSoup
import requests
import json
import re
import os
from pymongo import MongoClient
from urllib.parse import quote



headers = {"user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Safari/537.36"}
page = 'https://tiki.vn/'
res = requests.get(page, headers=headers)
src = res.text
soup = BeautifulSoup(src, 'html.parser')

categories = []

div_elements = soup.find_all('div', class_='styles__StyledItemV2-sc-oho8ay-1 bHIPhv')
for div in div_elements:
    a_elements = div.find_all('a')
    for a in a_elements:
        href = a.get('href')  
        categories.append(href)
    if len(categories)==26:
        break


id_product = []
for p in categories:
    num = 1
    while (True):
        if num == 2:
            break
        print('Process {} page {}'.format(p, num))
        page = 'https://tiki.vn/api/personalish/v1/blocks/listings?limit=40&include=advertisement&aggregations=2&trackity_id=9f0706eb-cddc-44cf-3333-67df659d9c40&category={}&page={}'.format(re.sub(r'\D','',p), num)
        result = requests.get(page, headers=headers).text
        if (json.loads(result).get('data')==None or json.loads(result).get('data')==[]) :
            break
        for item in json.loads(result).get('data'):
            if item.get('id') not in id_product:
                id_product.append(item.get('id'))
            else:
                continue
        #time.sleep(random.randrange(1, 2))
        num += 1


myclient = MongoClient('mongodb://localhost:27017/')


db_name = 'tiki_database'
col_name = 'tiki_product'


if db_name in myclient.list_database_names():
    
    myclient.drop_database(db_name)
    print(f"Database '{db_name}' đã bị xóa.")


mydb = myclient[db_name]
mycol = mydb[col_name]



data = []
data_err = []

for img in id_product[:10]:
    print('Process {}'.format(img))
    api = 'https://tiki.vn/api/v2/products/{}'.format(img)
    try:
        res = urllib.request.urlopen(api)
    except:
        continue
    soup = BeautifulSoup(res.read(), 'html.parser')
    try:
        data.append(json.loads(soup.text))
        mycol.insert_one(json.loads(soup.text))
    except json.decoder.JSONDecodeError as e:
        print("JSONDecodeError:", e)
        print("Response Content:", soup.text)
    n_image = 0
    os.makedirs(os.path.join('images', str(img)), exist_ok=True)
    for n in range(len(json.loads(soup.text).get('images'))):
        try:
            urllib.request.urlretrieve(json.loads(soup.text).get('images')[n_image].get('base_url'),
                                    os.path.join('images', str(img), str(img) + '_' + str(n_image) + '.jpg'))
            n_image += 1
        except Exception as e:
            print(f"An error occurred: {e}")
            continue

        
    #time.sleep(random.randrange(0, 3))

jsonString = json.dumps(data, ensure_ascii=False)
with open("data.json", "w", encoding='utf-8') as outfile:
    outfile.write(jsonString)

mycol.create_index('short_description')