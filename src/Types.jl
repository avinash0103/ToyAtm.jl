abstract type AbstractDevice end
struct CPU <: AbstractDevice end
struct GPU <: AbstractDevice end

abstract type AbstractAtmosphere end
abstract type AbstractOpacity end
abstract type AbstractForwardModel end
abstract type AbstractObservation end
abstract type AbstractLikelihood end
abstract type AbstractParameterTransform end
abstract type AbstractRetrievalMethod end

"""Fixed atmospheric configuration and planetary geometry."""
struct AtmState{T<:AbstractFloat} <: AbstractAtmosphere
    n_layers::Int
    p_bottom::T
    p_top::T
    gravity::T
    planet_radius::T
    star_radius::T
end

"""Small set of live physical parameters used by the forward model."""
mutable struct AtmParameters{T}
    mean_mass::T
    temp_eq::T
end

"""
Fixed/precomputed atmosphere plus the user's current parameters.

T = storage precision.
A = concrete array type (CPU Array or GPU CuArray).
D = device type.
The stored parameters use T. During AD, a temporary AtmParameters{S}
can be passed to the forward model, where S may be a Dual type.
"""
struct FullAtm{T,A<:AbstractVector{T},D<:AbstractDevice} <: AbstractAtmosphere
    state::AtmState{T}
    parameters::AtmParameters{T}
    pressure::A
    logqfactor::A
    logqcenter::A
    pressure_center::A
    dlogq::T
    device::D
end

struct ToyOpacity{T,A<:AbstractVector{T}} <: AbstractOpacity
    wavelength::A
    sigma_1::A
    sigma_2::A
    sigma_rayleigh::A
end

struct TransitModel{A<:FullAtm,O<:AbstractOpacity} <: AbstractForwardModel
    atmosphere::A
    opacity::O
end

struct TransitObservation{T,A<:AbstractVector{T}} <: AbstractObservation
    wavelength::A
    depth::A
    uncertainty::A
end

struct GaussianLikelihood <: AbstractLikelihood end

"""Identity: retrieval vector is [H, X1, X2]."""
struct PhysicalTransform <: AbstractParameterTransform end

"""
AD-friendly transform:
H = H_ref * exp(u1)
X1 = abundance_max * logistic(u2)
X2 = abundance_max * logistic(u3)
"""
struct LogitTransform{T} <: AbstractParameterTransform
    h_ref::T
    abundance_max::T
end

struct GradientAscent{B,R<:AbstractParameterTransform} <: AbstractRetrievalMethod
    backend::B
    transform::R
    step_size::Float64
    maxiters::Int
    gtol::Float64
end

"""Adapter around a user-supplied MultiNest runner."""
struct MultiNestRetrieval{F,R<:AbstractParameterTransform} <: AbstractRetrievalMethod
    runner::F
    transform::R
end

struct RetrievalResult{A,T}
    parameters::A
    loglikelihood::T
    iterations::Int
    converged::Bool
end
