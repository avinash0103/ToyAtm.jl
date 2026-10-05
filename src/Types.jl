abstract type AbstractDevice end
struct CPU <: AbstractDevice end
struct GPU <: AbstractDevice end

abstract type AbstractAtmosphere end

abstract type AbstractPlanetType end

struct HotJupiter <: AbstractPlanetType end
struct Terrestrial <: AbstractPlanetType end
struct EarthLike <: AbstractPlanetType end
struct SubNeptune <: AbstractPlanetType end


"""Fixed atmospheric configuration and planetary geometry."""
struct AtmState{T<:AbstractFloat,A<:AbstractVector{T}} <: AbstractAtmosphere
    n_layers::Int
    p_bottom::T
    p_top::T
    star_radius::T
    P::A
    Pc::A
end

function AtmState(
    n_layers::Int,
    p_bottom::T,
    p_top::T,
    star_radius::T
) where {T<:AbstractFloat}
    P = T(10) .^ range(log10(p_bottom), log10(p_top), length = n_layers + 1)
    Pc = @. sqrt(P[1:end-1] * P[2:end])
    return AtmState(n_layers, p_bottom, p_top, star_radius, P,Pc)
end

"""Small set of live physical parameters used by the forward model."""
mutable struct AtmParameters{T}
    mean_mass::T
    temp_eq::T
    planet_radius::T
    gravity::T
    scale_height::T
    thickness::T
end

"""
Fixed/precomputed atmosphere plus the user's current parameters.

T = storage precision.
A = concrete array type (CPU Array or GPU CuArray).
D = device type.
The stored parameters use T. During AD, a temporary AtmParameters{S}
can be passed to the forward model, where S may be a Dual type.
"""
struct FullAtm{T,B,A<:AbstractVector{T}} <: AbstractAtmosphere
    state::AtmState{T,A}
    parameters::AtmParameters{B}
    number_density::A
end



struct PlanetSpectrum{T,A<:AbstractVector{T},P<:AbstractPlanetType}
    planet_type::P
    wavelength::A
    n_scale_heights::A
    depth::A
end



