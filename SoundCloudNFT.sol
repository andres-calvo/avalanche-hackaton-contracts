// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoundCloudNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    // Estructura para almacenar información del NFT, incluyendo el link a la canción
    struct Song {
        string soundCloudLink;
        uint256 likes;
    }

    // Mapping para almacenar la información de cada NFT
    mapping(uint256 => Song) private _songs;

    // Evento cuando un NFT recibe un like
    event SongLiked(uint256 indexed tokenId, uint256 newLikeCount);

    // Constructor que inicializa el NFT
    constructor(
        address initialOwner
    ) ERC721("SoundCloudNFT", "SCNFT") Ownable(initialOwner) {
        _nextTokenId = 1; // Inicializar token ID
    }

    // Función para acuñar (mint) un nuevo NFT con el link de la canción en SoundCloud
    function mintNFT(
        address to,
        string memory soundCloudLink
    ) public onlyOwner {
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);
        _songs[tokenId] = Song(soundCloudLink, 0); // Crear una nueva canción con 0 likes
        _nextTokenId++;
    }

    // Función para ver el link de SoundCloud de un NFT
    function getSoundCloudLink(
        uint256 tokenId
    ) public view returns (string memory) {
        require(_nextTokenId >= tokenId, "NFT no existe");
        return _songs[tokenId].soundCloudLink;
    }

    // Función para ver la cantidad de likes de un NFT
    function getLikes(uint256 tokenId) public view returns (uint256) {
        require(_nextTokenId >= tokenId, "NFT no existe");
        return _songs[tokenId].likes;
    }

    // Función para dar like a un NFT (cualquiera puede dar like)
    function likeSong(uint256 tokenId) public {
        require(_nextTokenId >= tokenId, "NFT no existe");
        _songs[tokenId].likes++;
        emit SongLiked(tokenId, _songs[tokenId].likes);
    }

    function updateSoundCloudLink(
        uint256 tokenId,
        string memory newLink
    ) public onlyOwner {
        require(_nextTokenId >= tokenId, "NFT no existe");
        _songs[tokenId].soundCloudLink = newLink;
    }
}
