import { test } from 'node:test';
import { strict as assert } from 'node:assert';
import { parseScanTarget } from '../scripts/parse-scan-target.mjs';

test('accepts ordinary public domains and normalizes case', () => {
  assert.equal(parseScanTarget('REM scan: Sorabyte.IN'), 'sorabyte.in');
  assert.equal(parseScanTarget('REM scan: www.example.com'), 'www.example.com');
});

test('rejects injection attempts, private hosts and malformed titles', () => {
  for (const title of [
    'example.com', 'REM scan: localhost', 'REM scan: 127.0.0.1',
    'REM scan: foo.local', 'REM scan: foo.test', 'REM scan: bad..com',
    'REM scan: example.com && echo hacked', 'REM scan: https://example.com',
    'REM scan: example.com\nother', 'REM scan: -bad.example.com',
  ]) assert.throws(() => parseScanTarget(title), title);
});
