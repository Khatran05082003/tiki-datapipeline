from pymongo import MongoClient
import pandas as pd


client = MongoClient('mongodb://localhost:27017/')
db = client['tiki_database']
collection = db['tiki_product']


projection = {
    'id': 1,
    'sku':1,
    'name': 1,
    'price': 1,
    'type':1,
    'short_description':1,
    'price':1,
    'discount':1,
    'discount_rate':1,
    'rating_average':1,
    'review_count':1,
    'review_text':1,
    'favourite_count':1,
    'inventory_status':1,
    'day_ago_created':1,
    'quantity_sold':1,
    'current_seller':1,
    'price_comparison':1,
    'categories':1,
    'inventory_status':1,
    'inventory_type':1,
    'is_fresh':1,
    'all_time_quantity_sold':1,
    'stock_item':1,
    'is_tier_pricing_available':1,
    'is_tier_pricing_eligible':1,
    'return_policy':1,
    '_id':0 
}


data = list(collection.find({}, projection))


df = pd.DataFrame(data)


df.to_csv('data.csv', index=False)

