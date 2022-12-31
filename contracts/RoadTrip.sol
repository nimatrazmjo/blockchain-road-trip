// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <=0.8.17;

interface Driveable {
    function startEngine() external;

    function stopEngine() external;

    function fuelUp(uint256 litres) external;

    function drive(uint256 kilometers) external;

    function kilometersRemaining() external view returns (uint256);
}

abstract contract GasVehicle is Driveable {
    uint256 litresRemaining;
    bool started;

    modifier sufficientTankSize(uint256 litres) {
        require(litresRemaining + litres <= getFuelCapacity());
        _;
    }

    modifier sufficientKilometersRemaining(uint256 kilometers) {
        require(kilometersRemaining() >= litresRemaining);
        _;
    }

    modifier notStarted() {
        require(!started);
        _;
    }

    modifier isStarted() {
        require(started);
        _;
    }

    function startEngine() external notStarted {
        started = true;
    }

    function stopEngine() external isStarted {
        started = false;
    }

    function fuelUp(uint256 litres)
        external
        sufficientTankSize(litres)
        notStarted
    {
        litresRemaining += litres;
    }

    function drive(uint256 kilometers)
        external
        isStarted
        sufficientKilometersRemaining(kilometers)
    {
        litresRemaining -= kilometers / getKilometersPerLitre();
    }

    function kilometersRemaining() public view returns (uint256) {
        return litresRemaining * getKilometersPerLitre();
    }

    function getKilometersPerLitre() public view virtual returns (uint256);

    function getFuelCapacity() public view virtual returns (uint256);
}

contract Car is GasVehicle {
    uint256 fuelTankSize;
    uint256 kilometersPerLitre;

    constructor(uint256 _fuelTankSize, uint256 _kilometersPerLitre) {
        fuelTankSize = _fuelTankSize;
        kilometersPerLitre = _kilometersPerLitre;
    }

    function getKilometersPerLitre() public view override returns (uint256) {
        return kilometersPerLitre;
    }

    function getFuelCapacity() public view override returns (uint256) {
        return fuelTankSize;
    }
}
