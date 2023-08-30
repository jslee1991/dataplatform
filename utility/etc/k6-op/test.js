import http from 'k6/http';
import encoding from 'k6/encoding';

export const options={
  vus: 10,
  duration: '60m',
  discardResponseBodies: true,
  insecureSkipTLSVerify: true,
  logLevel: 'error'
}

const username = 'admin';
const password = 'admin';

export default function () {
	//  const credentials = `${username}:${password}`;
	//  const encodedCredentials = encoding.b64encode(credentials)
  const options = {
    headers: {
   //   'Authorization': `Basic ${encodedCredentials}`,
      'Content-Type': 'application/json',
    },
  };

  const url = 'http://192.168.0.118:9200/test_index1'

	  const requestBody = {
          "value": {
                  "type": "JSON",
                  "data": {
                          "name": "testUser"
                  }
          }
  }


  const res = http.post(url, JSON.stringify(requestBody), options);

}
