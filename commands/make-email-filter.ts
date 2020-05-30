/**
 * Addresses to block
 */
const addresses = [
  'everlane.com',
  'petsmart',
  'allmodern',
  'trupanion',
  'draftkings',
  'grailed',
  'nakedapartments',
  'yelp',
  'squaremktg',
  'urban-x',
  'khanacademy',
  'codecademy',
  'shoprunner',
  'bluestone',
  'nfl',
  'petfinder',
  'superdupersf',
  'youngandreckless',
  'neo4j',
  'jetblue',
  'transparentlabs',
  'newrelic',
  'everybodyfights',
  'open.mit.edu',
  'experience.capitalone.com',
  'thehustle.co',
  'dataiku',
  'mfp.underarmour.com',
  'mail.society6.com',
  'news@rcn.com',
  'CustomerAdvocate@carvana.com',
  'news.mindbody.io',
  'doctorondemand.com',
  'bu.edu',
  'crewcollectivecaf',
]

const base = "from:(" + addresses.reduce((s, a, i) => `${s},'${a}`) + ")',

console.log(base)