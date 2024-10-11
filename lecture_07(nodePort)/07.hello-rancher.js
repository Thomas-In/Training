import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { target: 20, duration: '60s' },  // stay at 20 users for 60sec
    { target: 40, duration: '60s' },  // stay at 40 users for 60sec
    { target: 0, duration: '10s' },   // ramp-down
  ],
};

export default function () {
  const result = http.get('http://192.168.31.51:30000');
  sleep(1);
  check(result, {
    'http response status code is 200': result.status === 200,
  });
  console.log(JSON.stringify(result));
}