-- Q6b: DEX program name mapping — top 20 programs by swap events, H1 2026
-- Purpose: resolve Jupiter's routing targets from program addresses to names.
-- Note: names taken from Solscan's public program labels, verified individually.
-- Note: covers the top 20 of 89 programs (~93.65% of swap events); the rest is
--   reported as 'Unmapped'.
-- Note: of these 20, only Manifest carries Solscan's verified-program badge.
SELECT dex_program, dex_name FROM (VALUES
  ('pAMMBay6oceH9fJKBRHGP5D4bD4sWpmSwMn52FMfXEA',  'PumpSwap'),
  ('9H6tua7jkLhdm3w8BvgpTn5LZNU7g4ZynDmCiNN3q6Rp', 'HumidiFi'),
  ('whirLbMiicVdio4qvUfM5KAg6Ct8VwpYzGff3uctyCc',  'Orca Whirlpool'),
  ('BiSoNHVpsVZW2F7rx2eQ59yQwKxzU5NvBcmKshCSUypi', 'BisonFi'),
  ('LBUZKhRxPF3XUpBCjp4YzTKgLccjZhTSDM9YuVaPwxo',  'Meteora DLMM'),
  ('CAMMCzo5YL8w4VFF8KVHrK22GGUsp5VTaW7grrKgrWqK', 'Raydium CLMM'),
  ('ALPHAQmeA7bjrVuccPsYPiCvsi428SNwte66Srvs4pHA', 'AlphaQ'),
  ('SV2EYYJyRz2YhfXwXnhNAevDEui5Q6yrfyo13WtupPF',  'SolFi V2'),
  ('TessVdML9pBGgG9yGks7o4HewRaXVAMuoVj4x83GLQH',  'Tessera V'),
  ('goonuddtQRrWqqn5nFyczVKaie28f3kDkHWkHtURSLE',  'GoonFi V2'),
  ('HpNfyc2Saw7RKkQd8nEL4khUcuPhQ7WwY1B2qjx8jxFq', 'PancakeSwap'),
  ('cpamdpZCGKUy5JxQXB4dcpGPiikHawvSWAd6mEn1sGG',  'Meteora DAMM v2'),
  ('675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8', 'Raydium AMM v4'),
  ('MNFSTqtC93rEfYHB6hF82sKdZpUDFWkViLByLd1k1Ms',  'Manifest'),
  ('ZERor4xhbUycZ6gb9ntrhqscUcZmAbQDjEAtCf4hbZY',  'ZeroFi'),
  ('AQU1FRd7papthgdrwPTTq5JacJh8YtwEXaBfKU3bTz45', 'Aquifer'),
  ('SCoRcH8c2dpjvcJD6FiPbCSQyQgu3PcUAWj2Xxx3mqn',  'Scorch'),
  ('CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C', 'Raydium CPMM'),
  ('QuaNtZsgYRe5Z9Bk4LZ4cTD9tbkVoyCNf1R2BN9bBDv',  'Quantum'),
  ('goonERTdGsjnkZqWuVjs73BZ3Pb9qoCUdBUL17BnS5j',  'GoonFi')
) AS t (dex_program, dex_name)
