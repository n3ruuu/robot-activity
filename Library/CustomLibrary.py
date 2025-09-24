import requests
import random
import string

class CustomLibrary:
    def get_first_five_users(self):
        # Fetch all users from the API
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        
        # Only take the first 5 users
        first_five = users[:5]
        
        # Add birthday, password, and stateAbbr to each user
        for i in first_five:
            i["birthday"] = self.get_random_birthday()
            i["password"] = self.generate_password()
            i["stateAbbr"] = str(i["address"]["street"][0])+str(i["address"]["suite"][0])+str(i["address"]["city"][0])
        
        print(first_five)
        return first_five

    def get_last_five_users(self):
        # Fetch all users from the API
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
        users = response.json()
        
        # Take users 6-10 (index 5-9)
        last_five = users[5:10]
        
        # Add birthday, password, and stateAbbr to each user
        for i in last_five:
            i["birthday"] = self.get_random_birthday()
            i["password"] = self.generate_password()
            i["stateAbbr"] = str(i["address"]["street"][0])+str(i["address"]["suite"][0])+str(i["address"]["city"][0])
        
        print(last_five)
        return last_five

    def get_random_birthday(self):
        return str(random.randint(1,12)) + str(random.randint(1,28)) + str(random.randint(1999, 2006))

    def generate_password(self, length=8):
        chars = string.ascii_letters + string.digits + "!@#&%"
        return ''.join(random.choice(chars) for _ in range(length))
