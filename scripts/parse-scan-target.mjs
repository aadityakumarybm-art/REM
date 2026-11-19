import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

export function parseScanTarget(title) {
  const prefix = 'REM scan: ';
  if (!title.startsWith(prefix)) throw new Error('Issue title must start with REM scan: ');
  const domain = title.slice(prefix.length).trim().toLowerCase();
  if (domain.length > 253 || domain.length < 4) throw new Error('Invalid domain length');
  const labels = domain.split('.');
  if (labels.length < 2) throw new Error('Use a public domain, such as example.com');
  for (const label of labels) {
    if (label.length < 1 || label.length > 63 || !/^[a-z0-9-]+$/.test(label) || label.startsWith('-') || label.endsWith('-')) {
      throw new Error('Invalid domain label');
    }
  }
  const tld = labels.at(-1);
  if (!/^[a-z]{2,63}$/.test(tld)) throw new Error('Invalid top-level domain');
  if (['local', 'localhost', 'internal', 'test', 'invalid', 'example'].includes(tld)) {
    throw new Error('Private or reserved hostnames are not allowed');
  }
  return domain;
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  try {
    console.log(parseScanTarget(process.argv[2] ?? ''));
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
