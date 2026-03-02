# CIDR Explainer (Conversational Draft)

Author: Shannon Eldridge-Kuehn c. 2026

CIDR is one of those things that looks scarier than it is, mostly because a lot of subnet explanations start in binary and stay there forever. The trick is to stop seeing CIDR as math homework and start seeing it as a boundary. An IP address is a starting point, and the slash is the fence line that tells you how big the neighborhood is.

For IPv4, everything is 32 bits total. That means the only math you really need is this: host bits = 32 minus the CIDR prefix, and number of addresses = 2 to the power of host bits. A `/24` leaves 8 host bits, so 2^8 gives you 256 addresses. A `/16` leaves 16 host bits, so 2^16 gives you 65,536 addresses. A `/30` leaves 2 host bits, so 2^2 gives you 4 addresses. Once you see that, subnet sizes stop feeling like trivia and start feeling obvious.

IPv6 works the same way, only the address space is 128 bits. So host bits = 128 minus the prefix. The part that makes IPv6 feel different is that we do not generally carve tiny subnets to conserve space, because the space is enormous. The standard subnet is `/64`, which leaves 64 bits for device identity, and the protocol expects that boundary for common behaviors like SLAAC.

That is the moment IPv6 becomes readable. IPv4 often feels like you are budgeting scarce addresses. IPv6 feels like you are designing clean structure. When cloud services ask for an allowlist value, you are applying that same boundary idea to security: allow one house (`/32`), allow a street (`/24`), or allow a whole region (please do not, unless you mean it).

The scripts in this repo exist because the practical version of this story is almost always the same: you want to allowlist your current source IP so you can securely administer a service without opening it to the world. That is why you will see `/32` show up everywhere in the examples. It is a single host boundary, expressed as CIDR.
