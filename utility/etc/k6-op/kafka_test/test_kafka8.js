import http from 'k6/http';
import encoding from 'k6/encoding';

export const options={
  vus: 2,
  duration: '10m',
  discardResponseBodies: true,
  insecureSkipTLSVerify: true,
//  logLevel: 'error'
}

//const username = 'admin';
//const password = 'admin';

export default function () {
//  const credentials = `${username}:${password}`;
//  const encodedCredentials = encoding.b64encode(credentials)
  const options = {
    headers: {
 //     'Authorization': `Basic ${encodedCredentials}`,
      'ContentType': 'application/json',
    },
  };

  const url = 'http://192.168.0.50:32041/topics/test-topic8'

  const requestBody = {"records":[{"value":"YmxhaGJsYWg="}]}
		//		{
//	  "value": {
//		  "type": "JSON",
//		  "data": {
//			  "name": "testUser"
//		  }
//	  }
//  }

  const res = http.post(url, JSON.stringify(requestBody), options);

}

//import requests
//import json
//
//headers = {
//    'Content-Type': 'application/vnd.kafka.json.v2+json',
//}
//
//data = '{"records":[{"value":{"id":"probiotics"}}]}'
//
//response = requests.post('http://192.168.0.50:32041/topics/test-topcis', headers=headers, data=data)
//
//print(response)
//print(json.dumps(response.json(), indent=4))
